class Staff < ActiveRecord::Base
  load_mappings
  include Common::Staff
end
