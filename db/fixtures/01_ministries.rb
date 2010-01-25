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
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 12
  ministry.name = 'Western Region'
  ministry.parent_id = 2
end

Ministry.seed(:name) do |ministry|
  ministry.id = 13
  ministry.name = 'Quebec'
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
  ministry.parent_id = 11
end

Ministry.seed(:name) do |ministry|
  ministry.id = 21
  ministry.name = 'UNB'
  ministry.ministries_count = 0
  ministry.parent_id = 11
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

Ministry.seed(:name) do |ministry|
  ministry.id = 30
  ministry.name = "Queen's"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontari & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 31
  ministry.name = "Windsor"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontari & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 32
  ministry.name = "U du Q"
  ministry.ministries_count = 0
  ministry.parent_id = 13 # Quebec
end

Ministry.seed(:name) do |ministry|
  ministry.id = 33
  ministry.name = "U of R"
  ministry.ministries_count = 0
  ministry.parent_id = 12 # Western Region
end

Ministry.seed(:name) do |ministry|
  ministry.id = 34
  ministry.name = "Brock"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 35
  ministry.name = "Fanshawe"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 36
  ministry.name = "MTA"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 37
  ministry.name = "COTR"
  ministry.ministries_count = 0
  ministry.parent_id = 12 # Western Region
end

Ministry.seed(:name) do |ministry|
  ministry.id = 38
  ministry.name = "Sheridan"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 39
  ministry.name = "Trent"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 40
  ministry.name = "LakeU"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end

Ministry.seed(:name) do |ministry|
  ministry.id = 41
  ministry.name = "TWU"
  ministry.ministries_count = 0
  ministry.parent_id = 12 # Western Region
end

Ministry.seed(:name) do |ministry|
  ministry.id = 42
  ministry.name = "UOIT"
  ministry.ministries_count = 0
  ministry.parent_id = 11 # Ontario & Maritimes
end
