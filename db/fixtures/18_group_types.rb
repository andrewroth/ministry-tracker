c4c = Ministry.find_by_name 'Campus for Christ'

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Discipleship Group (DG)'
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Prayer Group'
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Servant Team'
end

GroupType.seed(:ministry_id, :group_type) do |gt|
  gt.ministry_id = c4c.id
  gt.group_type = 'Other'
end
