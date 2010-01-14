# Groups are weekly events, like bible studies, discipleship times, main meetings
class Group < ActiveRecord::Base
  load_mappings

  LEVELS = [ 'leader', 'co-leader', 'member', 'interested' ]
  LEVEL_TITLES = [ 'Leader', 'Co Leader', 'Member', 'Interested' ]

  def self.promote(level)
    throw "invalid level '#{level}'" unless LEVELS.include?(level)
    return LEVEL_TITLES.first if level == 'leader'
    Group::LEVEL_TITLES[Group::LEVELS.index(level) - 1].titleize
  end

  validates_presence_of :name
  validates_presence_of :group_type
  
  belongs_to :ministry
  belongs_to :campus
  belongs_to :group_type
  belongs_to :dorm
  
  has_many :group_involvements, :dependent => :destroy
  has_many :people, :through => :group_involvements
  has_many :leaders, :class_name => "Person", :through => :group_involvements
  has_many :co_leaders, :class_name => "Person", :through => :group_involvements
  has_many :members, :class_name => "Person", :through => :group_involvements
  has_many :interesteds, :class_name => "Person", :through => :group_involvements
  has_many :requesters, :class_name => 'Person', :through => :group_involvements
  has_many :requests, :class_name => 'GroupInvolvement', :conditions => { :requested => true }

  def is_leader(p) in_association(leaders, p) end
  def is_co_leader(p) in_association(co_leaders, p) end
  def is_member(p) in_association(members, p) end
  def is_interested(p) in_association(interesteds, p) end
  def has_requested(p) in_association(requesters, p) end

  def in_association(a, p)
    a.include?(p)
  end
end
