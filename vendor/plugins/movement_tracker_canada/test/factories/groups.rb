require "#{RAILS_ROOT}/test/factories/semesters"

Factory.define :group_1, :class => Group, :singleton => true do |g|
  g.id '1'
  g.name '\'Foo\''
  g.group_type_id '2'
  g.ministry_id '1'
  g.campus_id '1'
  g.semester_id 14
end

Factory.define :group_2, :class => Group, :singleton => true do |g|
  g.id '4'
  g.name '\'Foo\''
  g.group_type_id '2'
  g.ministry_id '1'
  g.semester_id 14
  g.campus_id '2'
end

Factory.define :group_3, :class => Group, :singleton => true do |g|
  g.id '2'
  g.name '\'Bar\''
  g.group_type_id '1'
  g.ministry_id '1'
  g.campus_id '2'
  g.semester_id 14
end

Factory.define :group_4, :class => Group, :singleton => true do |g|
  g.id '3'
  g.name '\'Other\''
  g.group_type_id '3'
  g.semester_id 14
  g.campus_id '2'
  g.ministry_id '1'
end

Factory.define :group_5, :class => Group, :singleton => true do |g|
  g.id '5'
  g.name '\'Group for Fall 2009\''
  g.group_type_id '1'
  g.semester_id 10
  g.campus_id '2'
  g.ministry_id '1'
end

Factory.define :group_6, :class => Group, :singleton => true do |g|
  g.id '6'
  g.name '\'Group for Summer 2010\''
  g.group_type_id '3'
  g.semester_id 12
  g.campus_id '2'
  g.ministry_id '2'
end
