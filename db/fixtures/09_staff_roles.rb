ministry = Ministry.first

StaffRole.seed(:name) do |sr|
  sr.name = 'Campus Coordinator'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 5
  sr.involved = true
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Missionary'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 6
  sr.involved = true
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Admin'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 7
  sr.involved = false
end
