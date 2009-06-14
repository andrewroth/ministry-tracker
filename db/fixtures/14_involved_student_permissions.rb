require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Involved Student'

inherit_seed('13_student_permissions')

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :directory
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :search
end