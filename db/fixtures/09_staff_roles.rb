ministry = Ministry.first

StaffRole.seed(:name) do |sr|
  sr.name = 'Campus Coordinator'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 5
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Missionary'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 6
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Admin'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 7
end
