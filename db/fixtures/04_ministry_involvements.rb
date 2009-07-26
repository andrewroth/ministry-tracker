MinistryInvolvement.seed(:person_id, :ministry_id) do |mi|
  mi.person_id = 1
  mi.ministry_id = 1
  mi.ministry_role_id = 7 # Admin
  mi.admin = true
end
