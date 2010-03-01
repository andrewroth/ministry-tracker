Factory.define :ministryrole_1, :class => StaffRole, :singleton => true  do |m|
  m.id '1'
  m.ministry_id '1'
  m.name 'Admin'
  m.position '1'
  m.type 'StaffRole'
end

Factory.define :ministryrole_2, :class => StaffRole, :singleton => true  do |m|
  m.id '2'
  m.name 'Campus Coordinator'
  m.ministry_id '1'
  m.position '2'
  m.type 'StaffRole'
end

Factory.define :ministryrole_3, :class => StudentRole, :singleton => true  do |m|
  m.id '4'
  m.ministry_id '1'
  m.name 'Ministry Leader'
  m.position '4'
  m.description 'a student who oversees a campus, eg LINC leader'
  m.type 'StudentRole'
  m.involved 'true'
end

Factory.define :ministryrole_4, :class => StudentRole, :singleton => true  do |m|
  m.id '5'
  m.ministry_id '1'
  m.name 'Student Leader'
  m.position '5'
  m.type 'StudentRole'
  m.involved 'true'
end

Factory.define :ministryrole_5, :class => OtherRole, :singleton => true  do |m|
  m.id '6'
  m.ministry_id '1'
  m.name 'Random Person'
  m.position '6'
  m.type 'OtherRole'
end

Factory.define :ministryrole_6, :class => StudentRole, :singleton => true  do |m|
  m.id '7'
  m.ministry_id '1'
  m.name 'Student'
  m.position '7'
  m.type 'StudentRole'
end

Factory.define :ministryrole_7, :class => OtherRole, :singleton => true  do |m|
  m.id '8'
  m.ministry_id '3'
  m.name 'Chicago Role'
  m.position '8'
  m.type 'OtherRole'
end

Factory.define :ministryrole_8, :class => OtherRole, :singleton => true  do |m|
  m.id '9'
  m.ministry_id '6'
  m.name 'Will I Exist?'
  m.position '9'
  m.type 'OtherRole'
end

Factory.define :ministryrole_9, :class => StaffRole, :singleton => true  do |m|
  m.id '10'
  m.ministry_id '1'
  m.name 'Staff'
  m.position '1'
  m.type 'StaffRole'
end
