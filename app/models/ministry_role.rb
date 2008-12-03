class MinistryRole < ActiveRecord::Base
  load_mappings
  
  acts_as_list :scope => :ministry
  
  belongs_to :ministry
  has_many :ministry_involvements
  has_many :people, :through => :ministry_involvements
  
  validates_presence_of :name, :ministry_id, :type
end
