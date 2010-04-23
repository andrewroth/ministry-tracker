class AddStatsPermissions < ActiveRecord::Migration

  NEW_PERMISSIONS = [{ :description => "View Stats Tab", :controller => "stats", :action => "index" },
                     { :description => "Submit Weekly Stats", :controller => "weekly_reports", :action => "new" },
                     { :description => "Submit Semester Stats", :controller => "semester_reports", :action => "new" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_id => 1,  :controller => "stats", :action => "index" },
                                   { :ministry_role_id => 13, :controller => "stats", :action => "index" },
                                   { :ministry_role_id => 1,  :controller => "weekly_reports", :action => "new" },
                                   { :ministry_role_id => 13, :controller => "weekly_reports", :action => "new" },
                                   { :ministry_role_id => 1,  :controller => "semester_reports", :action => "new" },
                                   { :ministry_role_id => 13, :controller => "semester_reports", :action => "new" }]

  def self.up
    NEW_PERMISSIONS.each do |permission|
      p = Permission.new(permission)
      p.save
    end

    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      permission_id = Permission.find(:first, :conditions => { :controller => mrp[:controller], :action => mrp[:action] } ).id

      p = MinistryRolePermission.new( {:permission_id => permission_id, :ministry_role_id => mrp[:ministry_role_id] } )
      p.save
    end
  end

  def self.down
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      permission_id = Permission.find(:first, :conditions => { :controller => mrp[:controller], :action => mrp[:action] } ).id

      p = MinistryRolePermission.find(:first, :conditions => {:permission_id => permission_id, :ministry_role_id => mrp[:ministry_role_id] } )
      p.destroy
    end

    NEW_PERMISSIONS.each do |permission|
      p = Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] })
      p.destroy
    end
  end
end
