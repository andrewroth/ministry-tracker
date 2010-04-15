Factory.define :freetime_1, :class => FreeTime, :singleton => true do |f|
  f.id '1'
  f.start_time '21600'
  f.end_time '23400'
  f.day_of_week '2'
  f.timetable_id '1'
  f.css_class 'good'
  f.weight '1.00'
end

Factory.define :freetime_2, :class => FreeTime, :singleton => true do |f|
  f.id '2'
  f.start_time '23400'
  f.end_time '77400'
  f.day_of_week '1'
  f.timetable_id '1'
  f.css_class 'bad'
  f.weight '0.00'
end

Factory.define :freetime_3, :class => FreeTime do |f|
  f.id '3'
  f.start_time '43200'
  f.end_time '52200'
  f.day_of_week '1'
  f.timetable_id '2'
  f.css_class 'good'
  f.weight '1.00'
end

Factory.define :freetime_4, :class => FreeTime do |f|
  f.id '4'
  f.start_time '45000'
  f.end_time '59400'
  f.day_of_week '2'
  f.timetable_id '2'
  f.css_class 'ok'
  f.weight '0.70'
end

