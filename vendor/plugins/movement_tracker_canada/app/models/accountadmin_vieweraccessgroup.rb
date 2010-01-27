class AccountadminVieweraccessgroup < ActiveRecord::Base
  load_mappings

  belongs_to :user, :foreign_key => :viewer_id
  belongs_to :accountadmin_accessgroup, :foreign_key => :accessgroup_id
end
