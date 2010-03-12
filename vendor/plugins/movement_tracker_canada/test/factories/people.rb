Factory.define :person_1, :class => Person, :singleton => true do |p|
  p.id '50000'
  p.first_name 'Josh'
  p.person_legal_fname 'Josh'
  p.last_name 'Starcher'
  p.person_legal_lname 'Starcher'
  p.middle_name 'Lee'
  p.preferred_name 'Josh'
  p.major 'Philosophy'
  p.minor 'Computer Science'
  p.birth_date '07/07/1982'
  p.gender '1'
end

Factory.define :person_2, :class => Person, :singleton => true do |p|
  p.id '3000'
  p.first_name 'fred'
  p.person_legal_fname 'fred'
  p.last_name 'anderson'
  p.person_legal_lname 'anderson'
  p.gender 'M'
end

Factory.define :person_3, :class => Person, :singleton => true do |p|
  p.id '2000'
  p.first_name 'sue'
  p.person_legal_fname 'sue'
  p.last_name 'johnson'
  p.person_legal_lname 'johnson'
  p.gender 'F'
end

Factory.sequence :person_person_id do |n|
  n
end

Factory.sequence :person_last_name do |n|
  "A#{n}"
end

Factory.define :person, :class => Person do |c|
  c.id { Factory.next(:person_person_id) }
  c.first_name 'A'
  c.person_legal_fname 'A'
  c.last_name { Factory.next(:person_last_name) }
  c.person_legal_lname { |c| c.last_name }
end

Factory.define :person_5, :class => Person, :singleton => true do |p|
  p.id '4000'
  p.first_name 'NoMinistry'
  p.person_legal_fname 'NoMinistry'
  p.last_name 'Involvements'
  p.person_legal_lname 'Involvements'
end

Factory.define :person_6, :class => Person, :singleton => true do |p|
  p.id '4001'
  p.first_name '\'Ministry\''
  p.person_legal_fname '\'Ministry\''
  p.last_name '\'Leader\''
  p.person_legal_lname '\'Leader\''
end

Factory.define :person_7, :class => Person, :singleton => true do |p|
  p.id '4002'
  p.first_name '\'Ministry\''
  p.person_legal_fname '\'Ministry\''
  p.last_name '\'Leader\''
  p.person_legal_lname '\'Leader\''
end

Factory.define :person_111, :class => Person, :singleton => true do |p|
  p.id '111'
  p.first_name 'Random'
  p.person_legal_fname 'Random'
  p.last_name 'Person'
  p.person_legal_lname 'Person'
end


