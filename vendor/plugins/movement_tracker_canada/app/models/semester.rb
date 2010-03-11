class Semester < ActiveRecord::Base
  unloadable
  
  load_mappings
  include Legacy::Stats::Semester
end
