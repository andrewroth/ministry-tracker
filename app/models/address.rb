class Address < ActiveRecord::Base
  include Common::Address
  load_mappings
end
