class Timetable < ActiveRecord::Base
  load_mappings
  
  EARLIEST = 6.hours.to_i
  LATEST = 22.hours.to_i
  INTERVAL = 60.minutes.to_i
  
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  has_many :free_times, :class_name => "FreeTime", :foreign_key => _(:timetable_id, :free_time)
end
