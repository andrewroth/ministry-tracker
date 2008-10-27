class Dorm < ActiveRecord::Base
  load_mappings
  validates_presence_of :name
end
