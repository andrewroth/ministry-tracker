class FixSearchPermissionNames < ActiveRecord::Migration
  def self.up
    p = Permission.find(:first, :conditions => { :controller => "search", :action => "return_people" } )
    p.action = "people"
    p.save!

    p = Permission.find(:first, :conditions => { :controller => "search", :action => "return_groups" } )
    p.action = "groups"
    p.save!
  end

  def self.down
    p = Permission.find(:first, :conditions => { :controller => "search", :action => "people" } )
    p.action = "return_people"
    p.save!

    p = Permission.find(:first, :conditions => { :controller => "search", :action => "groups" } )
    p.action = "return_groups"
    p.save!
  end
end
