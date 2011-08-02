class PersonEventAttendee < ActiveRecord::Base
  load_mappings
  include Common::Core::PersonEventAttendee
end
