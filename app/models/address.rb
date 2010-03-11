class Address < ActiveRecord::Base
  include Common::Core::Address
  load_mappings
end
