require_model 'campus'

class Campus < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :region, :foreign_key => :region_id
  belongs_to :state, :foreign_key => _(:state_id)

  validates_no_association_data :people, :campus_involvements, :groups, :ministry_campuses, :ministries, :dorms

  def type=(val) '' end
  def country=(val) '' end
  def enrollment() '' end
end
