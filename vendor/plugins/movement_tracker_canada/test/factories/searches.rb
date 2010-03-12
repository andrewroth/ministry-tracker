Factory.define :search_1, :class => Search do |s|
  s.id '1'
  s.person_id '50000'
  s.options '{}'
  s.query 'Person.person_id IN(50000)'
  s.tables '{}'
end
