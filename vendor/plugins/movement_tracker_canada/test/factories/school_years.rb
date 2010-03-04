Factory.define :schoolyear_1, :class => SchoolYear, :singleton => true do |s|
  s.id '1'
  s.name 'Freshman'
end

Factory.define :schoolyear_2, :class => SchoolYear, :singleton => true do |s|
  s.id '2'
  s.name 'Sophomore'
end