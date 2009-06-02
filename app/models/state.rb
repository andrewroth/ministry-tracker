class State < ActiveRecord::Base
  load_mappings

  belongs_to :country
  has_many :campuses, :foreign_key => _(:state_id, :campus)
end
