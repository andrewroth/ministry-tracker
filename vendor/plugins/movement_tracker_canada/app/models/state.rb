require_model 'state'

class State < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :people, :foreign_key => :province_id

  validates_no_association_data :campuses, :people
end
