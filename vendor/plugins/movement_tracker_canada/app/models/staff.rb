class Staff < ActiveRecord::Base
  
  load_mappings
  
  # This method will return the person id associated with a given staff id
  def self.find_person_id(staff_id)
    find(:first, :conditions => {_(:id) => staff_id})["#{_(:person_id)}"]
  end
  
end