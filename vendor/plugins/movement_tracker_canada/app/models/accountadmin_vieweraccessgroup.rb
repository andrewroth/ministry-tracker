class AccountadminVieweraccessgroup < ActiveRecord::Base
  load_mappings

  belongs_to :accountadmin_accessgroup, :foreign_key => :accessgroup_id, :class_name => 'AccountadminAccessgroup'
  belongs_to :user, :foreign_key => :viewer_id, :class_name => 'User'
end
