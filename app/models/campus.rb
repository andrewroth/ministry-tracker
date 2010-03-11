class Campus < ActiveRecord::Base
  include Common::Core::Campus
  load_mappings
end
