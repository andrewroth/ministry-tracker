Factory.define :state_1, :class => State do |c|
  c.id '1'
  c.name 'California'
  c.abbreviation 'CA'
end

Factory.define :state_2, :class => State do |c|
  c.id '2'
  c.name 'Wyoming'
  c.abbreviation 'WY'
end
