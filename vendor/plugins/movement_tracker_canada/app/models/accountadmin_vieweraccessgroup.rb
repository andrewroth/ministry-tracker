class AccountadminVieweraccessgroup < ActiveRecord::Base
  load_mappings

  belongs_to :accountadmin_accessgroup, :foreign_key => :accessgroup_id
  belongs_to :user, :foreign_key => :viewer_id
end
