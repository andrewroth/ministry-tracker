# This file is intended to be used with seed_fu fixtures

# Helper: Find the Permission ID for a given controller and action
def p_id(controller, action)
  Permission.find_by_controller_and_action(controller.to_s,action.to_s).id
end

def inherit_seed(f)
  # load another seed file, and add a flag so we know it's being loaded manually from this helper
  @seed_fu_being_inherited = true
  load Rails.root.join("db", "fixtures", f+'.rb')
  @seed_fu_being_inherited = false
end

def set_or_inherit_ministry_role_id(name)
  if @seed_fu_being_inherited
    @ministry_role_id
  else
    @ministry_role_id = MinistryRole.find_by_name(name).id
  end
end