require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Student'

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :join
end