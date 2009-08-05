class Dorm < ActiveRecord::Base
  belongs_to :campus
  has_many :groups
  load_mappings
  validates_presence_of :name
end
