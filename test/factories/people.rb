Factory.define :person_1, :class => Person do |p|
  p.id '50000'
  p.user_id '1'
  p.first_name 'Josh'
  p.last_name 'Starcher'
  p.middle_name 'Lee'
  p.preferred_name 'Josh'
  p.year_in_school 'Alumni'
  p.level_of_school 'Undergrad'
  p.graduation_date '2004-06-15'
  p.major 'Philosophy'
  p.minor 'Computer Science'
  p.birth_date '1982-07-07'
  p.bio "I\'m an MK"
  p.gender '1'
end

Factory.define :person_2, :class => Person do |p|
  p.id '3000'
  p.first_name 'fred'
  p.user_id '2'
  p.gender 'M'
end

Factory.define :person_3, :class => Person do |p|
  p.id '2000'
  p.first_name 'sue'
  p.user_id '3'
  p.gender 'F'
end

Factory.define :person, :class => Person do |c|
  c.sequence(:id) {|n| n }
  c.first_name 'A'
  c.sequence(:last_name) {|n| "A#{n}" }
end

Factory.define :person_5, :class => Person do |p|
  p.id '4000'
  p.user_id '4'
end

Factory.define :person_6, :class => Person do |p|
  p.id '4001'
  p.user_id '5'
  p.first_name '\'Ministry\''
  p.last_name '\'Leader\''
end

Factory.define :person_7, :class => Person do |p|
  p.id '4002'
  p.user_id '6'
  p.first_name '\'Ministry\''
  p.last_name '\'Leader\''
end
