ministry = Ministry.first

StaffRole.seed(:name) do |sr|
  sr.name = 'Campus Coordinator'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 6
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Staff'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 7
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Staff Alumni'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 8
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Admin'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 9
end
