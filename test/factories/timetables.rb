Factory.define :timetable_1, :class => Timetable, :singleton => true do |t|
  t.id '1'
  t.person_id '50000'
end

Factory.define :timetable_2, :class => Timetable do |t|
  t.id '2'
  t.person_id '2000'
end

Factory.define :timetable_3, :class => Timetable do |t|
  t.id '3'
  t.person_id '3000'
end


Factory.define :timetable_6, :class => Timetable do |t|
  t.id '6'
  t.person_id '4001'
end
