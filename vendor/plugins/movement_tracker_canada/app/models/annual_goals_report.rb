class AnnualGoalsReport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::AnnualGoalsReport
end
