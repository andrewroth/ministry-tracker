class AddSummerReportSubmitAndReviewPermissions < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Summer report front page", :controller => "summer_reports", :action => "index" },
                     { :description => "Show summer report", :controller => "summer_reports", :action => "show" },
                     { :description => "Submit summer report", :controller => "summer_reports", :action => "new" },
                     { :description => "Resubmit summer report", :controller => "summer_reports", :action => "edit" },
                     { :description => "Search for summer report reviewers", :controller => "summer_reports", :action => "search_for_reviewers" },

                     { :description => "Review summer reports", :controller => "summer_report_reviewers", :action => "index" },
                     { :description => "Approve/disapprove summer reports", :controller => "summer_report_reviewers", :action => "edit" }
                    ]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader",  :permission_controller => "summer_reports", :permission_action => "index" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_reports", :permission_action => "index" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_reports", :permission_action => "index" },
                                   
                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_reports", :permission_action => "show" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_reports", :permission_action => "show" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_reports", :permission_action => "show" },

                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_reports", :permission_action => "new" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_reports", :permission_action => "new" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_reports", :permission_action => "new" },

                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_reports", :permission_action => "edit" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_reports", :permission_action => "edit" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_reports", :permission_action => "edit" },

                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_reports", :permission_action => "search_for_reviewers" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_reports", :permission_action => "search_for_reviewers" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_reports", :permission_action => "search_for_reviewers" },

                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_report_reviewers", :permission_action => "index" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_report_reviewers", :permission_action => "index" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_report_reviewers", :permission_action => "index" },

                                   { :ministry_role_name => "Team Leader",  :permission_controller => "summer_report_reviewers", :permission_action => "edit" },
                                   { :ministry_role_name => "Team Member",  :permission_controller => "summer_report_reviewers", :permission_action => "edit" },
                                   { :ministry_role_name => "Staff",        :permission_controller => "summer_report_reviewers", :permission_action => "edit" }
                                  ]



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
