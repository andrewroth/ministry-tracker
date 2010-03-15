class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Campus
  include Common::Core::Ca::Campus
end
