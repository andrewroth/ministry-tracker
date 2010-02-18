Factory.define :people_1, :class => People do |p|
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
   p.bio '"I\\'m an MK"'
   p.gender '1'
end

Factory.define :people_2, :class => People do |p|
   p.id '3000'
   p.first_name 'fred'
   p.user_id '2'
   p.gender 'M'
end

Factory.define :people_3, :class => People do |p|
   p.id '2000'
   p.first_name 'sue'
   p.user_id '3'
   p.gender 'F'
end

Factory.define :people_4, :class => People do |p|
   p.id  i 
   p.first_name 'A'
   p.last_name A i 
end

Factory.define :people_5, :class => People do |p|
   p.id '4000'
   p.user_id '4'
end

Factory.define :people_6, :class => People do |p|
   p.id '4001'
   p.user_id '5'
   p.first_name '\'Ministry''
   p.last_name '\'Leader''
end

Factory.define :people_7, :class => People do |p|
   p.id '4002'
   p.user_id '6'
   p.first_name '\'Ministry''
   p.last_name '\'Leader''
end
