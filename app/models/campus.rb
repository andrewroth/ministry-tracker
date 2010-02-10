class Campus < ActiveRecord::Base
  include Common::Campus
  load_mappings
end
