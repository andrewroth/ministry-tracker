class WeeklyReport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::WeeklyReport
end