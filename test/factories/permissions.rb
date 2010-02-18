Factory.define :permission_1, :class => Permission do |p|
   p.id '1'
   p.action 'foo'
   p.controller 'bar'
end

Factory.define :permission_2, :class => Permission do |p|
   p.id '2'
   p.action 'new'
   p.controller 'campus_involvements'
end

Factory.define :permission_3, :class => Permission do |p|
   p.id '3'
   p.action 'new'
   p.controller 'people'
end
