class AccountadminVieweraccessgroup < ActiveRecord::Base
  load_mappings

  belongs_to :accountadmin_accessgroup, :foreign_key => :accessgroup_id, :class_name => 'AccountadminAccessgroup'
  belongs_to :user, :foreign_key => :viewer_id, :class_name => 'User'

  # This method will return all the access ids associated with a given viewer id
  def self.find_access_ids(viewer_id)
    find(:all, :select => _(:accessgroup_id), :conditions => {_(:viewer_id) => viewer_id})
  end
end
