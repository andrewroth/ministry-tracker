require_model 'country'

class Country < ActiveRecord::Base
  
  def country() country_desc end
  def is_closed() 
    nil 
  end
end
