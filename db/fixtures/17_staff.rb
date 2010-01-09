require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Staff'

inherit_seed('16_ministry_leader_permissions')

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :directory
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :search
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :advanced
end
