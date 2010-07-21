class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Ca::Campus
  include Legacy::Stats::Core::Campus
end
