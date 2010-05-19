class AddSubmitMonthlyReportPermission < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "Submit Monthly Report Stats", :controller => "monthly_reports", :action => "new" }, 
                    { :description => "View Monthly Report Stats", :controller => "stats", :action => "monthly_report" }]

  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission)
    end
  end

  def self.down

    NEW_PERMISSIONS.each do |permission|
      Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } ).destroy
    end

  end
end
