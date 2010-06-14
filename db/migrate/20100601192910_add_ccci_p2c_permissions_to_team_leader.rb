class AddCcciP2cPermissionsToTeamLeader < ActiveRecord::Migration
NEW_PERMISSIONS = [{ :description => "View Power to Change Reports", :controller => "stats", :action => "show_p2c_report" }, 
                    { :description => "View Campus for Christ Internationnal Reports", :controller => "stats", :action => "show_ccci_report" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Team Leader",  :permission_index => 1 }]

  def self.up
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr_id })
    end
  end

  def self.down
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      MinistryRolePermission.find(:first, :conditions => { :permission_id => permission_id, :ministry_role_id => mr_id }).destroy
    end
  end
end
