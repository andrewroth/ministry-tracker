class Region < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :campuses
  belongs_to :country, :foreign_key => :country_id

  validates_no_association_data :campuses

  # This method will return an array of all regions associated with a given country
  def self.find_regions(country_id)
    find(:all, :conditions => ["#{_(:country_id)} <= ?",country_id]).collect{ |s| [s.description]}
  end

  # This method will return the region id associated with a given description
  def self.find_region_id(description)
    find(:first, :conditions => {_(:description) => description}).id
  end
end
