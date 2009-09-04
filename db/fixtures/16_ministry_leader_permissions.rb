require "seed_fu_helper"

ministry_role_id = set_or_inherit_ministry_role_id 'Ministry Leader'

inherit_seed('15_student_leader_permissions')
