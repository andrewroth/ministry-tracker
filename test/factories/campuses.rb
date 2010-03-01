Factory.define :campus_1, :class => Campus, :singleton => true do |c|
  c.id '1'
  c.name 'University of California-Davis'
  c.state 'CA'
  c.type 'College'
  c.country 'USA'
end

Factory.define :campus_2, :class => Campus, :singleton => true do |c|
  c.id '2'
  c.name 'Sacramento State'
  c.state 'CA'
  c.type 'College'
  c.country 'USA'
end

Factory.define :campus_3, :class => Campus, :singleton => true do |c|
  c.id '3'
  c.name 'Campus of Wyoming'
  c.state 'WY # 1 is Wyoming id'
  c.country 'USA'
end
