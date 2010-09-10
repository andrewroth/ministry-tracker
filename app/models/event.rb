class Event < ActiveRecord::Base
  load_mappings
  include Common::Core::Event
  include Common::Core::Ca::Event
end
