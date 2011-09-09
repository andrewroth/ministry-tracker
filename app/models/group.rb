# Groups are weekly events, like bible studies, discipleship times, main meetings
class Group < ActiveRecord::Base
  load_mappings

  LEADER = 'leader'
  CO_LEADER = 'co-leader'
  MEMBER = 'member'
  INTERESTED = 'interested'
  LEVELS = [ LEADER, CO_LEADER, MEMBER, INTERESTED ]
  LEVEL_TITLES = [ 'Leader', 'Co Leader', 'Member', 'Interested' ]

  def self.promote(level)
    throw "invalid level '#{level}'" unless LEVELS.include?(level)
    return LEVEL_TITLES.first if level == 'leader'
    Group::LEVEL_TITLES[Group::LEVELS.index(level) - 1].titleize
  end

  validates_presence_of :ministry
  validates_presence_of :campus
  validates_presence_of :name
  validates_presence_of :group_type
  unless Cmt::CONFIG[:semesterless_groups]
    validates_presence_of :semester_id
  end

  
  belongs_to :ministry
  belongs_to :campus
  belongs_to :group_type
  belongs_to :dorm
  belongs_to :semester
  
  has_many :group_involvements, :dependent => :destroy
  has_many :people, :through => :group_involvements
  has_many :leaders, :class_name => "Person", :through => :group_involvements
  has_many :co_leaders, :class_name => "Person", :through => :group_involvements
  has_many :members, :class_name => "Person", :through => :group_involvements
  has_many :interesteds, :class_name => "Person", :through => :group_involvements
  has_many :requesters, :class_name => 'Person', :through => :group_involvements
  has_many :requests, :class_name => 'GroupInvolvement', :conditions => { :requested => true }
  has_many :invitations, :class_name => "GroupInvitation"

  has_one :campus_ministry_group

#  after_save :update_collection_groups

  named_scope :current_and_next_semester, lambda {
    sid = Semester.current.id
    { :conditions => [ "semester_id in (#{sid}, #{sid+1})" ],
      :order => "semester_id ASC"
    }
  }

  def is_leader(p) in_association(leaders, p) end
  def is_co_leader(p) in_association(co_leaders, p) end
  def is_member(p) in_association(members, p) end
  def is_interested(p) in_association(interesteds, p) end
  def has_requested(p) in_association(requesters, p) end
  def is_associated(p) in_association(people, p) end

  def in_association(a, p)
    a.include?(p)
  end

  def derive_name(line = group_type.try(:collection_group_name))
    self[:name] = line.gsub("{{campus}}", campus.try(:short_name)).gsub("{{group_type}}", group_type.group_type).gsub("{{semester}}", semester.try(:desc))
  end

  def derive_ministry
    self.ministry = campus.try(:derive_ministry)
  end

  def update_collection_groups
    if campus_ministry_group
      derive_name
    end
  end

  def is_collection_group
    campus_ministry_group.present?
  end

  def deep_copy(override_attributes = {})
    new_group = Group.new self.attributes.merge(override_attributes)
    new_group.save!
    group_involvements.each do |inv|
      new_group.group_involvements.create :person_id => inv.person_id, 
        :level => inv.level, :requested => inv.requested
    end
    return new_group
  end

  def find_or_create_involvement(person, level)
    if LEVELS.index(level).present?
      gi = group_involvements.find_by_person_id(person.id)
      gi ||= group_involvements.new(:person_id => person.id)
      gi.level = level
      gi.save!
    end
  end

  def meeting_day_and_time_to_string()
    meeting_time = self.day.present? ? "#{Date::DAYNAMES[self.day]}'s" : ""

    midnight = Time.now.beginning_of_day
    if self.start_time.present?
      meeting_time += " at " unless meeting_time.blank?
      meeting_time += "#{(midnight + self.start_time).to_s(:time)}"
      meeting_time += " to #{(midnight + self.end_time).to_s(:time)}" if self.end_time
    end

    meeting_time
  end
end
