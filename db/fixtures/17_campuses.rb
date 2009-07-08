c4c = Ministry.find_by_name 'Campus for Christ'
for c in Campus.all
  MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
    mc.campus_id = c.id
    mc.ministry_id = c4c.id
  end
end
