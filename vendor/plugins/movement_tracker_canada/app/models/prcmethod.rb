class Prcmethod < ActiveRecord::Base
  unloadable
  
  load_mappings
  include Legacy::Stats::Prcmethod
end
