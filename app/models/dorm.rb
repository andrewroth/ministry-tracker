class Dorm < ActiveRecord::Base
  belongs_to :campus
  load_mappings
  validates_presence_of :name
end
