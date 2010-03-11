class Prc < ActiveRecord::Base
  unloadable
  
  load_mappings
  include Legacy::Stats::Prc
end
