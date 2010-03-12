Factory.define :state_1, :class => State, :singleton => true do |s|
  s.id '1'
  s.name 'California'
  s.abbrev 'CA'
  s.country_id '1'
end

Factory.define :state_2, :class => State, :singleton => true do |s|
  s.id '2'
  s.name 'Second State'
  s.abbrev 'SS'
  s.country_id '1'
end
