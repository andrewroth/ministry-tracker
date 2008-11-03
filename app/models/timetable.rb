class Timetable < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  has_many :busy_times, :class_name => "BusyTime", :foreign_key => _(:timetable_id, :busy_time)
end
