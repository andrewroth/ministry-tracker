class MinistryRolePermission < ActiveRecord::Base
  load_mappings
  belongs_to :ministry_role
  belongs_to :permission
  
  validates_presence_of :permission_id, :ministry_role_id
end
