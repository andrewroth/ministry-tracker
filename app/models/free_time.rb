class FreeTime < ActiveRecord::Base
  load_mappings
  belongs_to :timetable
end
