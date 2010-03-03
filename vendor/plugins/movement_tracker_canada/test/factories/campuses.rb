Factory.define :campus_1, :class => Campus, :singleton => true do |c|
  c.id '1'
  c.name 'University of California-Davis'
  c.state_id '1'
  c.campus_facebookgroup ''
  c.campus_gcxnamespace ''
end

Factory.define :campus_2, :class => Campus, :singleton => true do |c|
  c.id '2'
  c.name 'Sacramento State'
  c.state_id '1'
  c.campus_facebookgroup ''
  c.campus_gcxnamespace ''
end

Factory.define :campus_3, :class => Campus, :singleton => true do |c|
  c.id '3'
  c.name 'Campus of Wyoming'
  c.state_id '2'
  c.campus_facebookgroup ''
  c.campus_gcxnamespace ''
end
