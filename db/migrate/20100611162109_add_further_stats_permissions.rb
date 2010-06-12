class AddFurtherStatsPermissions < ActiveRecord::Migration

  NEW_PERMISSIONS = [{ :description => "Salvation Story Synopses", :controller => "stats", :action => "salvation_story_synopses" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_id => 1,  :controller => "stats", :action => "salvation_story_synopses" },
                                   { :ministry_role_id => 13, :controller => "stats", :action => "salvation_story_synopses" }]

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
      p = Permission.find(:first, :conditions => { :controller => mrp[:controller], :action => mrp[:action] } )
      if p
        permission_id = p.id

        mr = MinistryRolePermission.find(:first, :conditions => {:permission_id => permission_id, :ministry_role_id => mrp[:ministry_role_id] } )
        mr.destroy if mr
      end
    end

    NEW_PERMISSIONS.each do |permission|
      p = Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] })
      p.destroy if p
    end
  end
end
