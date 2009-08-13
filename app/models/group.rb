# Groups are weekly events, like bible studies, discipleship times, main meetings
class Group < ActiveRecord::Base
  LEVELS = [ 'leader', 'co_leader', 'member', 'interested' ]
  LEVEL_TITLES = [ 'Leader', 'Co Leader', 'Member', 'Interested' ]

  def self.promote(level)
    throw "invalid level #{level}" unless LEVELS.include?(level)
    return LEVEL_TITLES.first if level == 'leader'
    Group::LEVEL_TITLES[Group::LEVELS.index(level) - 1].titleize
  end

  load_mappings
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
end
