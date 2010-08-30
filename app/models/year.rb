class Year < ActiveRecord::Base
  load_mappings
  include Common::Core::Year
  include Legacy::Stats::Year
end
