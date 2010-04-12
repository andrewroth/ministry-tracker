class AddStatsPermissions < ActiveRecord::Migration

#  NEW_PERMISSIONS = [ { :description => "View Stats Tab", :controller => "stats", :action => "index" },
#
#                      { :description => "View Year Summary", :controller => "all_staff", :action => "year_summary" },
#                      { :description => "Submit Weekly Stats", :controller => "all_staff", :action => "submit_weekly_stats" },
#                      { :description => "View Semester at a Glance", :controller => "all_staff", :action => "semester_at_a_glance" },
#                      { :description => "Select Semester/Campus for Viewing Indicated Decisions (needed for View Indicated Decisions)", :controller => "all_staff", :action => "indicated_decisions" },
#                      { :description => "Delete Indicated Decision", :controller => "all_staff", :action => "delete" },
#                      { :description => "Edit Indicated Decision", :controller => "all_staff", :action => "edit" },
#                      { :description => "View Indicated Decisions", :controller => "all_staff", :action => "decisions" },
#
#                      { :description => "View Monthly Summary by Campus", :controller => "campus_directors", :action => "monthly_summary_by_campus" },
#
#                      { :description => "View How People Came to Know Christ", :controller => "national_team", :action => "how_people_prayed_to_receive_christ" },
#                      { :description => "View Indicated Decisions", :controller => "national_team", :action => "indicated_decisions" },
#
#                      { :description => "View Summary by Week", :controller => "regional_team", :action => "summary_by_week" },
#                      { :description => "View Summary by Month", :controller => "regional_team", :action => "summary_by_month" },
#                      { :description => "View Summary by Campus", :controller => "regional_team", :action => "summary_by_campus" } ]

  NEW_PERMISSIONS = [ { :description => "View Stats Tab", :controller => "stats", :action => "index" },
                      { :description => "Submit Weekly Stats Numbers", :controller => "weekly_reports", :action => "new" },
                      { :description => "View Semester at a Glance report", :controller => "stats", :action => "semester_at_a_glance" } ]

  NEW_MINISTRY_ROLE_PERMISSIONS = [ { :ministry_role_id => 1,  :controller => "stats", :action => "index" },
                                    { :ministry_role_id => 13, :controller => "stats", :action => "index" },
                                    { :ministry_role_id => 1,  :controller => "weekly_reports", :action => "new" },
                                    { :ministry_role_id => 13, :controller => "weekly_reports", :action => "new" },
                                    { :ministry_role_id => 1,  :controller => "stats", :action => "semester_at_a_glance" },
                                    { :ministry_role_id => 13, :controller => "stats", :action => "semester_at_a_glance" }]

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
