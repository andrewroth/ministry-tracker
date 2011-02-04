class GroupInvolvement < ActiveRecord::Base
  load_mappings
  
  belongs_to :person
  belongs_to :leader, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEADER}'"
  belongs_to :co_leader, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::CO_LEADER}'"
  belongs_to :member, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::MEMBER}' and (requested is NULL || requested = false)"
  belongs_to :interested, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::INTERESTED}'"
  belongs_to :requester, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::MEMBER}' and requested = true"
  belongs_to :group
  
  validates_presence_of :group_id, :level
  
  named_scope :sorted, :joins => :person, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}"

  def join_notifications(base_url)
    recipients = group.leaders + group.co_leaders
    recipients.each do |leader|
      requested = self.requested
      interested = self.level == Group::INTERESTED
      group_name = group.name
      leader_first_name = leader.first_name
      leader_email = leader.email
      member_first_name = person.first_name
      member_last_name = person.last_name
      member_email = person.email
      member_phone = person.local_phone
      join_time = created_at
      school_year = person.campus_involvements.last.try(:school_year).try(:name)
      group_link = base_url + "/groups/#{group.id}"

      UserMailer.deliver_group_join_email(requested, interested, group_name, leader_first_name, leader_email, 
                                          member_first_name, member_last_name, member_email, member_phone, 
                                          join_time, school_year, group_link)
    end
  end

  def self.create_group_involvement(person_id, group_id, level, requested)
    # If the person is already in the group, find them. otherwise, create a new record
    gi = find_or_create_by_person_id_and_group_id(person_id, group_id)
    gi.level = level
    gi.requested = requested
    gi.save!
    return gi
  end
end
