Factory.define :semester_1, :class => Semester, :singleton => true do |s|
  s.id 1
  s.semester_id 1
  s.start_date 1.month.ago
end

Factory.define :semester_2, :class => Semester, :singleton => true do |s|
  s.id 2
  s.start_date 1.month.from_now
end
