class AddViewSemesterHighlightsPermission < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "View Semester Highlights Stats", :controller => "stats", :action => "semester_highlights" }]

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
