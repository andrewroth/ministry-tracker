class Year < ActiveRecord::Base
  unloadable
  
  load_mappings
  
  include Legacy::Stats::Year
end