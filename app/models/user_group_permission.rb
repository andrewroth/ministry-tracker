class UserGroupPermission < ActiveRecord::Base
  load_mappings
  
  belongs_to :permission
  belongs_to :user_group
end
