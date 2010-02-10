require_model 'country'

class Country < ActiveRecord::Base
  unloadable
  load_mappings

  set_primary_key "country_id"
  has_many :states, :foreign_key => :country_id
  has_many :regions, :foreign_key => :country_id
  has_many :people

  validates_no_association_data :states, :regions, :people

  def country() country_desc end
  def is_closed() 
    nil 
  end

  # This method will return the county id associated with a given description
  def self.find_country_id(description)
    find(:first, :conditions => ["#{_(:desc)} <= ?",description]).id
  end
end
