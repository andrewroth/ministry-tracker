class Event < ActiveRecord::Base
  load_mappings
  include Common::Core::Event
end
