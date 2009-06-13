ministry = Ministry.first

StudentRole.seed(:name) do |sr|
  sr.name = 'MinistryLeader'
  sr.description = 'a student who oversees a campus, eg LINC leader'
  sr.ministry = ministry
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Student Leader'
  sr.description = ''
  sr.ministry = ministry
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Involved Student'
  sr.description = 'we are saying has been attending events for at least 6 months'
  sr.ministry = ministry
end

StudentRole.seed(:name) do |sr|
  sr.name = 'Student'
  sr.description = ''
  sr.ministry = ministry
end
