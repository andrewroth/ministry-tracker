Ministry.seed(:name) do |ministry|
  ministry.id = 1
  ministry.name = 'Power to Change Ministries'
  ministry.ministries_count = 1
  ministry.parent_id = nil
end

Ministry.seed(:name) do |ministry|
  ministry.id = 2
  ministry.name = 'Campus for Christ'
  ministry.ministries_count = 12
  ministry.parent_id = 1
end

Ministry.seed(:name) do |ministry|
  ministry.id = 3
  ministry.name = 'Campus Alumni'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 4
  ministry.name = 'Ev Strat'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 5
  ministry.name = 'Global Impact'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 6
  ministry.name = 'Korean'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 7
  ministry.name = 'National'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 8
  ministry.name = 'National Ops'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 9
  ministry.name = 'New Scholars'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 10
  ministry.name = 'Other'
  ministry.ministries_count = 0
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 11
  ministry.name = 'Ontario and Atlantic Region'
  ministry.ministries_count = 6
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 12
  ministry.name = 'Western Region'
  ministry.ministries_count = 5
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 13
  ministry.name = 'Quebec'
  ministry.ministries_count = 3
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 14
  ministry.name = 'Guelph'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 15
  ministry.name = 'Mac'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 16
  ministry.name = 'Ottawa Metro'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 17
  ministry.name = 'Toronto Metro'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 18
  ministry.name = 'UWO'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 19
  ministry.name = 'Waterloo'
  ministry.ministries_count = 0
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 20
  ministry.name = 'Halifax Metro'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 21
  ministry.name = 'UNB'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 22
  ministry.name = 'U of A'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 23
  ministry.name = 'U of C'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 24
  ministry.name = 'U of M'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 25
  ministry.name = 'U of S'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 26
  ministry.name = 'Vancouver Metro'
  ministry.ministries_count = 0
  ministry.parent_id = 12
end

Ministry.seed(:name) do |ministry|
  ministry.id = 27
  ministry.name = 'Laval'
  ministry.ministries_count = 0
  ministry.parent_id = 13
end

Ministry.seed(:name) do |ministry|
  ministry.id = 28
  ministry.name = 'Montreal Metro'
  ministry.ministries_count = 0
  ministry.parent_id = 13
end

Ministry.seed(:name) do |ministry|
  ministry.id = 29
  ministry.name = 'Sherbrooke'
  ministry.ministries_count = 0
  ministry.parent_id = 13
end
