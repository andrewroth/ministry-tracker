Factory.define :semester_10, :class => Semester, :singleton => true do |p|
  p.id '10'
  p.desc 'Fall 2009'
  p.start_date '2009-09-01'
  p.year_id '1'
end

Factory.define :semester_11, :class => Semester, :singleton => true do |p|
  p.id '11'
  p.desc 'Winter 2010'
  p.start_date '2010-01-01'
  p.year_id '1'
end

Factory.define :semester_12, :class => Semester, :singleton => true do |p|
  p.id '12'
  p.desc 'Summer 2010'
  p.start_date '2010-05-01'
  p.year_id '1'
end

Factory.define :semester_13, :class => Semester, :singleton => true do |p|
  p.id '13'
  p.desc 'Fall 2010'
  p.start_date '2010-09-01'
  p.year_id '2'
end

Factory.define :current_semester, :class => Semester, :singleton => true do |p|
  p.id '14'
  p.desc 'Current Semester'
  p.start_date Date.today
  p.year_id '2'
end

Factory.define :next_semester, :class => Semester, :singleton => true do |p|
  p.id '15'
  p.desc 'Next Semester'
  p.start_date 1.month.from_now
  p.year_id '2'
end
