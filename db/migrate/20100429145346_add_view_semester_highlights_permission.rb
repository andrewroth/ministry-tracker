class AddViewSemesterHighlightsPermission < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "View Semester Highlights Stats", :controller => "stats", :action => "semester_highlights" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader",  :permission_index => 0 }]

  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission)
    end
    
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
    
    NEW_PERMISSIONS.each do |permission|
      Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } ).destroy
    end

  end
end
