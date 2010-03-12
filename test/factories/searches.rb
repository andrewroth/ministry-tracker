Factory.define :search_1, :class => Search, :singleton => true do |s|
  s.id '1'
  s.person_id '50000'
  s.options '{}'
  s.query 'Person.id IN(50000)'
  s.tables '{}'
end
