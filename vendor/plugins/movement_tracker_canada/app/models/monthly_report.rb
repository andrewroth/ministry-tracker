class MonthlyReport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::MonthlyReport
end
