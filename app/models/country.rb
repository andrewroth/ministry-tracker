class Country < ActiveRecord::Base
  load_mappings
  has_many :states
  
  def campus_list
    self.states.collect{|s| s.campuses}.flatten
  end
  
end
