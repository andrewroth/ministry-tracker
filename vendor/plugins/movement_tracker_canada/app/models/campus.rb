require_model 'campus'

class Campus < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :region, :foreign_key => :region_id
  belongs_to :state, :foreign_key => _(:state_id)
end
