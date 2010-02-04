require_model 'state'

class State < ActiveRecord::Base
  unloadable
  load_mappings

  validates_no_association_data :campuses
end
