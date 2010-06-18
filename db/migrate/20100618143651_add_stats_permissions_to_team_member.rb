class AddStatsPermissionsToTeamMember < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :controller => "stats", :action => "semester_highlights" },
                    { :controller => "stats", :action => "monthly_report" },
                    { :controller => "stats", :action => "show_p2c_report" },
                    { :controller => "semester_reports", :action => "new" },
                    { :controller => "monthly_reports", :action => "new" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Team Member",  :permission_index => 4 }]


  def self.up
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      if MinistryRolePermission.find(:all, :conditions => {:permission_id => permission_id, :ministry_role_id => mr_id}).empty?
        MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr_id })
      end
    end
  end

  def self.down
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      mrp_list = MinistryRolePermission.find(:all, :conditions => {:permission_id => permission_id, :ministry_role_id => mr_id})
      mrp_list.each{ |mrp| mrp.destroy }
    end
  end
end
