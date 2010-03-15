Factory.define :permission_1, :class => Permission, :singleton => true do |p|
  p.id '1'
  p.action 'foo'
  p.controller 'bar'
  p.description 'permission one'
end

Factory.define :permission_2, :class => Permission, :singleton => true do |p|
  p.id '2'
  p.action 'new'
  p.controller 'campus_involvements'
  p.description 'permission two'
end

Factory.define :permission_3, :class => Permission, :singleton => true do |p|
  p.id '3'
  p.action 'new'
  p.controller 'people'
  p.description 'permission three'
end
