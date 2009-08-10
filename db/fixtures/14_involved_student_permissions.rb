require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Involved Student'

inherit_seed('13_student_permissions')

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :compare_timetables
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :set_start_time
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :accept_request
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :new
end

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

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :add_student
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :change_view
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :change_ministry
end
