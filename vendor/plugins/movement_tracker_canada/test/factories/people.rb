Factory.define :person_1, :class => Person, :singleton => true do |p|
  p.id '50000'
  p.user_id '1'
  p.first_name 'Josh'
  p.last_name 'Starcher'
  p.middle_name 'Lee'
  p.preferred_name 'Josh'
  p.level_of_school 'Undergrad'
  p.graduation_date '06/15/2004'
  p.major 'Philosophy'
  p.minor 'Computer Science'
  p.birth_date '07/07/1982'
  p.bio "I\'m an MK"
  p.gender '1'
end

Factory.define :person_2, :class => Person, :singleton => true do |p|
  p.id '3000'
  p.first_name 'fred'
  p.last_name 'anderson'
  p.user_id '2'
  p.gender 'M'
end

Factory.define :person_3, :class => Person, :singleton => true do |p|
  p.id '2000'
  p.first_name 'sue'
  p.last_name 'johnson'
  p.user_id '3'
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
  c.last_name { Factory.next(:person_last_name) }
end

Factory.define :person_5, :class => Person, :singleton => true do |p|
  p.id '4000'
  p.user_id '4'
  p.first_name 'NoMinistry'
  p.last_name 'Involvements'
end

Factory.define :person_6, :class => Person, :singleton => true do |p|
  p.id '4001'
  p.user_id '5'
  p.first_name '\'Ministry\''
  p.last_name '\'Leader\''
end

Factory.define :person_7, :class => Person, :singleton => true do |p|
  p.id '4002'
  p.user_id '6'
  p.first_name '\'Ministry\''
  p.last_name '\'Leader\''
end

Factory.define :person_111, :class => Person, :singleton => true do |p|
  p.id '111'
  p.first_name 'Random'
  p.last_name 'Person'
end


