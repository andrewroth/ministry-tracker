class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Campus
end
