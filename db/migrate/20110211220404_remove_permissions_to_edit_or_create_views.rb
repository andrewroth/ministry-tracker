class RemovePermissionsToEditOrCreateViews < ActiveRecord::Migration
  PERMISSIONS = [{ :description => "Create Directory Views", :controller => "views", :action => "new" },
                 { :description => "Create Directory Views", :controller => "views", :action => "edit" }]

  MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 },
                               { :ministry_role_name => "Team Leader",  :permission_index => 0 },
                               { :ministry_role_name => "Staff",  :permission_index => 0 },
                               
                               { :ministry_role_name => "Team Member",  :permission_index => 1 },
                               { :ministry_role_name => "Team Leader",  :permission_index => 1 },
                               { :ministry_role_name => "Staff",  :permission_index => 1 }]


  def self.up
    MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      found_mrp = MinistryRolePermission.find(:first, :conditions => { :permission_id => permission_id, :ministry_role_id => mr_id })
      found_mrp.destroy unless found_mrp.nil?
    end
  end

  def self.down
    MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr_id })
    end
  end
  
end
