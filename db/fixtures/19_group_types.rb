c4c = Ministry.find_by_name 'Campus for Christ'

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Discipleship Group (DG)'
  gt.mentor_priority = true
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Movement Development Area (MDA)'
  gt.mentor_priority = true
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Prayer Group'
  gt.mentor_priority = true
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Servant Team'
  gt.mentor_priority = true
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Other'
  gt.mentor_priority = true
end
