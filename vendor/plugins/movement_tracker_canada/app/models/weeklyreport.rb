class Weeklyreport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::Weeklyreport
end