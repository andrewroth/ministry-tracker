class AddPermissionStatsViewMinistriesUnder < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "View stats of ministries under the current ministry involvement", :controller => "stats", :action => "view_ministries_under" }]

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
