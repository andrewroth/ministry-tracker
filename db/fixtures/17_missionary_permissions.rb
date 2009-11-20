require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Missionary'

inherit_seed('16_ministry_leader_permissions')

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :ministry_involvements, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :ministry_involvements, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :ministry_involvements, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :customize, :show
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :dorms, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :custom_attributes, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :involvement_questions, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :training_categories, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :training_questions, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :training_questions, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :manage, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :joingroup
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :campus_involvements, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :campus_involvements, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :campus_involvements, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :timetables, :show
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :timetables, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :staff, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :transfer
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :group_involvements, :change_level
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :views, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :views, :edit
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :view_columns, :new
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :people, :change_ministry_and_goto_directory
end
