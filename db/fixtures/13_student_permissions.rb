ministry_role_id = MinistryRole.find_by_name('Student').id

# Helper: Find the Permission ID for a given controller and action
def p_id(controller, action)
  Permission.find_by_controller_and_action(controller.to_s,action.to_s).id
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :index
end

MinistryRolePermission.seed(:ministry_role_id, :permission_id) do |rp|
  rp.ministry_role_id = ministry_role_id
  rp.permission_id = p_id :groups, :join
end