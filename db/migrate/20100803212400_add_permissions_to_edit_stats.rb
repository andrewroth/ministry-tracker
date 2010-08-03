class AddPermissionsToEditStats < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "Edit Monthly Report Stats", :controller => "monthly_reports", :action => "edit" },
                    { :description => "Edit Weekly Stats", :controller => "weekly_reports", :action => "edit" },
                    { :description => "Edit Semester Stats", :controller => "semester_reports", :action => "edit" },
                    { :description => "Edit Indicated Decisions", :controller => "prcs", :action => "edit" },
                    { :description => "Edit Annual Goals", :controller => "annual_goals_reports", :action => "edit" }]

  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end
  
  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?
    end
  end

  def self.down

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)
      p.destroy unless p.nil?
    end

  end
end
