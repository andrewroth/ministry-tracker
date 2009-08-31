require_model 'country'

class Country < ActiveRecord::Base
  
  def country() country_desc end
  def is_closed() 
    nil 
  end
  
  def campus_list
    if self.country_desc == 'Canada'
      Ministry.find_by_name('Campus for Christ').campuses
    else
      self.states.collect{|s| s.campuses}.flatten
    end
  end
  
end
