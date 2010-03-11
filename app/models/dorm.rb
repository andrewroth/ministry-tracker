class Dorm < ActiveRecord::Base
  load_mappings
  include Common::Core::Dorm
end
