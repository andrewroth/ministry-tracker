Factory.define :ministryrolepermission_1, :class => MinistryRolePermission do |m|
  m.id '1'
  m.ministry_role_id '1'
  m.permission_id '2'
end

Factory.define :ministryrolepermission_2, :class => MinistryRolePermission do |m|
  m.id '2'
  m.ministry_role_id '2'
  m.permission_id '1'
end

Factory.define :ministryrolepermission_4, :class => MinistryRolePermission do |m|
  m.id '4'
  m.ministry_role_id '4'
  m.permission_id '4'
end

Factory.define :ministryrolepermission_5, :class => MinistryRolePermission do |m|
  m.id '5'
  m.ministry_role_id '10'
  m.permission_id '4'
end
