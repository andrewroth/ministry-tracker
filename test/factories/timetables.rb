Factory.define :timetable_1, :class => Timetable, :singleton => true do |t|
  t.id '1'
  t.person_id '50000'
end

Factory.define :timetable_2, :class => Timetable do |t|
  t.id '2'
  t.person_id '2000'
end
