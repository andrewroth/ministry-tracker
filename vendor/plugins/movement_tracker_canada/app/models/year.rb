class Year < ActiveRecord::Base
  
  load_mappings
  
  # This method will return the year id associated with a given description
  def self.find_year_id(description)
    find(:first, :conditions => {_(:description) => description}).id
  end
  
  # This method will return the description associated with a given year id
  def self.find_year_description(id)
    find(:first, :conditions => {_(:id) => id}).description
  end
  
  # This method will return an array of all the years up to and including the current year
  def self.find_years(current_id)
    find(:all, :conditions => ["#{_(:id)} <= ?",current_id]).collect{ |y| [y.description] } 
  end
  
end