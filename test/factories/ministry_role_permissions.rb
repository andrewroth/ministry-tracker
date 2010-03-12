Factory.define :ministryrolepermission_1, :class => MinistryRolePermission, :singleton => true do |m|
  m.id '1'
  m.ministry_role_id '1'
  m.permission_id '2'
end

Factory.define :ministryrolepermission_2, :class => MinistryRolePermission, :singleton => true do |m|
  m.id '2'
  m.ministry_role_id '2'
  m.permission_id '1'
end
