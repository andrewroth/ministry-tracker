Factory.define :access_1, :class => Access, :singleton => true do |c|
  c.id '1'
  c.viewer_id '1'
  c.person_id '50000'
end

Factory.define :access_2, :class => Access, :singleton => true do |c|
  c.id '2'
  c.viewer_id '2'
  c.person_id '3000'
end

Factory.define :access_3, :class => Access, :singleton => true do |c|
  c.id '3'
  c.viewer_id '3'
  c.person_id '2000'
end

Factory.define :access_4, :class => Access, :singleton => true do |c|
  c.id '4'
  c.viewer_id '4'
  c.person_id '4000'
end

Factory.define :access_5, :class => Access, :singleton => true do |c|
  c.id '5'
  c.viewer_id '5'
  c.person_id '4001'
end

Factory.define :access_6, :class => Access, :singleton => true do |c|
  c.id '6'
  c.viewer_id '6'
  c.person_id '4002'
end
