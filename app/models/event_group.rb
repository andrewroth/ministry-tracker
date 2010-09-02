class EventGroup < ActiveRecord::Base
  load_mappings
  include Common::Core::EventGroup
end
