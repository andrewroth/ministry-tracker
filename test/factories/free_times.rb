Factory.define :freetime_1, :class => FreeTime, :singleton => true do |f|
  f.id '1'
  f.start_time '21600'
  f.end_time '23400'
  f.day_of_week '1'
  f.timetable_id '1'
end

Factory.define :freetime_2, :class => FreeTime, :singleton => true do |f|
  f.id '2'
  f.start_time '23400'
  f.end_time '79200'
  f.day_of_week '1'
  f.timetable_id '1'
  f.column 'value'
end
