class Region < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :campuses
  belongs_to :country, :foreign_key => :country_id

  validates_no_association_data :campuses
end
