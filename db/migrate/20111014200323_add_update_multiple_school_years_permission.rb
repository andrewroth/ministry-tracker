class AddUpdateMultipleSchoolYearsPermission < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Update multiple school years", :controller => "campus_involvements", :action => "update_multiple_school_years" },
                     { :description => "Edit multiple school years", :controller => "campus_involvements", :action => "edit_multiple_school_years" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader",  :permission_controller => "campus_involvements", :permission_action => "update_multiple_school_years" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "campus_involvements", :permission_action => "update_multiple_school_years" },
                                   { :ministry_role_name => "Ministry Leader",  :permission_controller => "campus_involvements", :permission_action => "update_multiple_school_years" },
                                   { :ministry_role_name => "Student Leader",  :permission_controller => "campus_involvements", :permission_action => "update_multiple_school_years" },
                                   { :ministry_role_name => "Staff",  :permission_controller => "campus_involvements", :permission_action => "update_multiple_school_years" },
                                   
                                   { :ministry_role_name => "Staff",  :permission_controller => "campus_involvements", :permission_action => "edit_multiple_school_years" },
                                   { :ministry_role_name => "Team Leader",  :permission_controller => "campus_involvements", :permission_action => "edit_multiple_school_years" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "campus_involvements", :permission_action => "edit_multiple_school_years" },
                                   { :ministry_role_name => "Ministry Leader",  :permission_controller => "campus_involvements", :permission_action => "edit_multiple_school_years" },
                                   { :ministry_role_name => "Student Leader",  :permission_controller => "campus_involvements", :permission_action => "edit_multiple_school_years" }]



  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end


  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?
    end

    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = Permission.first(:conditions => {:controller => mrp[:permission_controller], :action => mrp[:permission_action]})
      mr = MinistryRole.first(:conditions => {:name => mrp[:ministry_role_name]})
      if p && mr then
        MinistryRolePermission.create!({:permission_id => p.id, :ministry_role_id => mr.id})
      end
    end
  end


  def self.down

    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = Permission.first(:conditions => {:controller => mrp[:permission_controller], :action => mrp[:permission_action]})
      mr = MinistryRole.first(:conditions => {:name => mrp[:ministry_role_name]})
      if p && mr then
        mrp = MinistryRolePermission.first(:conditions => {:permission_id => p.id, :ministry_role_id => mr.id})
        mrp.destroy unless mrp.nil?
      end
    end

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)
      p.destroy unless p.nil?
    end

  end
end
