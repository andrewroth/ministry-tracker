class Staff < ActiveRecord::Base
  load_mappings
  include Common::Core::Staff
end
