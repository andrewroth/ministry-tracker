class MinistryRole < ActiveRecord::Base
  load_mappings
  
  belongs_to :ministry
  has_many :ministry_involvements
  has_many :people, :through => :ministry_involvements
end
