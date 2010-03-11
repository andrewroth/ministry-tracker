Factory.define :grouptype_1, :class => GroupType, :singleton => true do |g|
  g.id '1'
  g.ministry_id '1'
  g.group_type 'Bible Study'
  g.mentor_priority 'true'
end

Factory.define :grouptype_2, :class => GroupType, :singleton => true do |g|
  g.id '2'
  g.ministry_id '1'
  g.group_type 'Team'
  g.mentor_priority 'true'
end

Factory.define :grouptype_3, :class => GroupType, :singleton => true do |g|
  g.id '3'
  g.ministry_id '2'
  g.group_type 'Bible Study Chicago'
  g.mentor_priority 'true'
end
