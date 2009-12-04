c4c = Ministry.find_by_name 'Campus for Christ'
for c in Country.find_by_country_desc('Canada').states.collect(&:campuses).flatten # only cdn campuses
  MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
    mc.campus_id = c.id
    mc.ministry_id = c4c.id
  end
end

regnat = Campus.find_by_campus_desc("Regional / National")
MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = regnat.id
  mc.ministry_id = c4c.id
end

other = Campus.find_by_campus_desc("Other")
MinistryCampus.seed(:campus_id, :ministry_id) do |mc|
  mc.campus_id = other.id
  mc.ministry_id = c4c.id
end
