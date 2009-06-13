ministry = Ministry.first

OtherRole.seed(:name) do |r|
  r.name = 'Registration Incomplete'
  r.description = 'A leader has registered them, but user has not completed rego and signed the privacy policy'
  r.ministry = ministry
end

OtherRole.seed(:name) do |r|
  r.name = 'Approval Pending'
  r.description = 'They have applied, but a leader has not verified their application yet'
  r.ministry = ministry
end

OtherRole.seed(:name) do |r|
  r.name = 'Honourary Member'
  r.description = 'not a valid student or missionary, but we are giving them limited access anyway'
  r.ministry = ministry
end
