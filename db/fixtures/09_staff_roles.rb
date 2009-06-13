ministry = Ministry.first

StaffRole.seed(:name) do |sr|
  sr.name = 'Campus Coordinator'
  sr.description = ''
  sr.ministry = ministry
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Missionary'
  sr.description = ''
  sr.ministry = ministry
end

StaffRole.seed(:name) do |sr|
  sr.name = 'Admin'
  sr.description = ''
  sr.ministry = ministry
end
