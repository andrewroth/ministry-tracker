ministry = Ministry.first

StudentRole.seed(:name) do |sr|
  sr.name = 'Ministry Leader'
  sr.description = 'a student who oversees a campus, eg LINC leader'
  sr.ministry = ministry
  sr.position = 1
  sr.involved = true
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Student Leader'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 2
  sr.involved = true
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Involved Student'
  sr.description = 'we are saying has been attending events for at least 6 months'
  sr.ministry = ministry
  sr.position = 3
  sr.involved = true
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Student'
  sr.description = ''
  sr.ministry = ministry
  sr.position = 4
  sr.involved = false
end
