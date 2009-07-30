class Group < ActiveRecord::Base
  load_mappings
  validates_presence_of :name
  validates_presence_of :group_type
  
  belongs_to :ministry
  belongs_to :campus
  belongs_to :group_type
  belongs_to :dorm
  
  has_many :group_involvements
  has_many :people, :through => :group_involvements
  has_many :leaders, :class_name => "Person", :through => :group_involvements
  has_many :co_leaders, :class_name => "Person", :through => :group_involvements
end
