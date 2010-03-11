class Week < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::Week
  
end
