Factory.define :group_1, :class => Group, :singleton => true, :singleton => true do |g|
  g.id '1'
  g.name '\'Foo\''
  g.group_type_id '2'
  g.ministry_id '1'
  g.campus_id '1'
end

Factory.define :group_2, :class => Group, :singleton => true, :singleton => true do |g|
  g.id '4'
  g.name '\'Foo\''
  g.group_type_id '2'
  g.ministry_id '1'
end

Factory.define :group_3, :class => Group, :singleton => true, :singleton => true do |g|
  g.id '2'
  g.name '\'Bar\''
  g.group_type_id '1'
  g.ministry_id '1'
  g.campus_id '2'
end

Factory.define :group_4, :class => Group, :singleton => true, :singleton => true do |g|
  g.id '3'
  g.name '\'Other\''
  g.group_type_id '3'
end
