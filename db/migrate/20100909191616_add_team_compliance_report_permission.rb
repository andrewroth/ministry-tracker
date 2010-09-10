class AddTeamComplianceReportPermission < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "Show compliance report for team", :controller => "stats", :action => "team_compliance_report" }]

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
