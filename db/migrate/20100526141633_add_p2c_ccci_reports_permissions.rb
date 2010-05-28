class AddP2cCcciReportsPermissions < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "View Power to Change Reports", :controller => "stats", :action => "show_p2c_report" }, 
                    { :description => "View Campus for Christ Internationnal Reports", :controller => "stats", :action => "show_ccci_report" }]

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
