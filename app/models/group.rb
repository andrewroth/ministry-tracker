class Group < ActiveRecord::Base
  load_mappings
  self.inheritance_column = 'false'
  
  belongs_to :ministry
  belongs_to :campus
  
  has_many :group_involvements
  has_many :people, :through => :group_involvements
  has_many :leaders, :class_name => "Person", :through => :group_involvements
end