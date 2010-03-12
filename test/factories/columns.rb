Factory.define :column_1, :class => Column, :singleton => true do |c|
  c.id '1'
  c.title 'First Name'
  c.select_clause 'first_name'
  c.from_clause 'Person'
end

Factory.define :column_2, :class => Column, :singleton => true do |c|
  c.id '2'
  c.title 'Last Name'
  c.select_clause 'last_name'
  c.from_clause 'Person'
end

Factory.define :column_3, :class => Column, :singleton => true do |c|
  c.id '3'
  c.title 'Email'
  c.select_clause 'email'
  c.from_clause 'PermanentAddress'
  c.join_clause 'PermanentAddress.address_type = \'permanent\''
end

Factory.define :column_4, :class => Column, :singleton => true do |c|
  c.id '4'
  c.title 'Email2'
  c.select_clause 'email'
  c.from_clause 'EmergencyAddress'
  c.join_clause 'EmergencyAddress.address_type = \'emergency1\''
end
