Factory.define :permission_1, :class => Permission do |p|
  p.id '1'
  p.action 'foo'
  p.controller 'bar'
  p.description 'permission one'
end

Factory.define :permission_2, :class => Permission do |p|
  p.id '2'
  p.action 'new'
  p.controller 'campus_involvements'
  p.description 'permission two'
end

Factory.define :permission_3, :class => Permission do |p|
  p.id '3'
  p.action 'new'
  p.controller 'people'
  p.description 'permission three'
end

Factory.define :permission_4, :class => Permission do |p|
  p.id '4'
  p.action 'directory'
  p.controller 'people'
  p.description 'View Directory'
end

Factory.define :permission_5_sheldon, :class => Permission do |p|
  p.id '5'
  p.action 'update_multiple_roles'
  p.controller 'ministry_involvements'
  p.description 'Update multiple ministry involvement roles'
end

Factory.define :permission_5_hobbe, :class => Permission do |p|
  p.id '555' # originally 5
  p.action 'add_mentor_to_other'
  p.controller 'people'
  p.description 'Add mentor to other'
end

Factory.define :permission_6, :class => Permission do |p|
  p.id '6'
  p.action 'add_mentee_to_other'
  p.controller 'people'
  p.description 'Add mentee to other'
end

Factory.define :permission_7, :class => Permission do |p|
  p.id '7'
  p.action 'add_mentor'
  p.controller 'people'
  p.description 'Add mentor'
end

Factory.define :permission_8, :class => Permission do |p|
  p.id '8'
  p.action 'add_mentee'
  p.controller 'people'
  p.description 'Add mentee'
end

Factory.define :permission_9, :class => Permission do |p|
  p.id '9'
  p.action 'remove_mentor'
  p.controller 'people'
  p.description 'Remove mentor'
end

Factory.define :permission_10, :class => Permission do |p|
  p.id '10'
  p.action 'remove_mentee'
  p.controller 'people'
  p.description 'Remove mentee'
end

Factory.define :permission_11, :class => Permission do |p|
  p.id '11'
  p.action 'show_mentor'
  p.controller 'people'
  p.description 'Show mentor'
end

Factory.define :permission_12, :class => Permission do |p|
  p.id '12'
  p.action 'show_mentees'
  p.controller 'people'
  p.description 'Show mentees'
end

Factory.define :permission_14, :class => Permission do |p|
  p.id '14'
  p.action 'destroy'
  p.controller 'people'
  p.description 'Remove involvements' # also located in MinistryInvolvements under 'update roles'
end
