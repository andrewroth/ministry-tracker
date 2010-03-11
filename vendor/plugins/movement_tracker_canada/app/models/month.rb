class Month < ActiveRecord::Base
  unloadable
  
  load_mappings
  
  include Legacy::Stats::Month
end
