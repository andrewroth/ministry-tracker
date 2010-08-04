class GiveEditPermissionsToTeamMemberTeamLeader < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "Edit Monthly Report Stats", :controller => "monthly_reports", :action => "edit" },
                    { :description => "Edit Weekly Stats", :controller => "weekly_reports", :action => "edit" },
                    { :description => "Edit Semester Stats", :controller => "semester_reports", :action => "edit" },
                    { :description => "Edit Indicated Decisions", :controller => "prcs", :action => "edit" },
                    { :description => "Edit Annual Goals", :controller => "annual_goals_reports", :action => "edit" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 4 }]

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
