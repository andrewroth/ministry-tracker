class MinistryRolePermission < ActiveRecord::Base
  load_mappings
  belongs_to :ministry_role
  belongs_to :permission
end
