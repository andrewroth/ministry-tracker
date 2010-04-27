class SemesterReport < ActiveRecord::Base
  unloadable
  
  load_mappings

  include Legacy::Stats::SemesterReport
end
