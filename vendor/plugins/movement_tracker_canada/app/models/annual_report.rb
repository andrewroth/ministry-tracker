class AnnualReport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::AnnualReport
end