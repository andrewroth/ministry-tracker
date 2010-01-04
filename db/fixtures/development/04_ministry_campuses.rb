foo = Ministry.find_by_name 'foo'
bar = Ministry.find_by_name 'bar'

MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = Campus.all.first.id
  mc.ministry_id = foo.id
end

MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = Campus.all.second.id
  mc.ministry_id = foo.id
end

MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = Campus.all.second.id
  mc.ministry_id = bar.id
end

MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = Campus.all.third.id
  mc.ministry_id = bar.id
end
