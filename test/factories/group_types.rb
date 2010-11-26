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

Factory.define :grouptype_4, :class => GroupType, :singleton => true do |g|
  g.id '4'
  g.ministry_id '1'
  g.group_type 'Discipleship Group (DG)'
  g.mentor_priority 'true'
  g.collection_group_name "{{campus}} interested in a {{group_type}} for {{semester}}"
  g.has_collection_groups 1
end
