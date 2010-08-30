class EventCampus < ActiveRecord::Base
  load_mappings
  include Common::Core::EventCampus
end
