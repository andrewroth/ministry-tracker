class AddEditMultipleMinistryRolesPermission < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Edit Multiple Ministry Roles", :controller => "ministry_involvements", :action => "edit_multiple_roles" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 },
                                   { :ministry_role_name => "Team Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Staff",  :permission_index => 0 },
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Involved Student",  :permission_index => 0 },
                                   { :ministry_role_name => "Student Leader",  :permission_index => 0 }]

  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end

  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?
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
      found_mrp = MinistryRolePermission.find(:first, :conditions => { :permission_id => permission_id, :ministry_role_id => mr_id })
      found_mrp.destroy unless found_mrp.nil?
    end

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)
      p.destroy unless p.nil?
    end
  end
end
