class AddPrcPermissions < ActiveRecord::Migration

  NEW_PERMISSIONS = [{ :description => "View All Indicated Decision Reports", :controller => "prcs", :action => "index" },
                     { :description => "Edit Indicated Decision Reports", :controller => "prcs", :action => "edit" }]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_id => 1,  :controller => "prcs", :action => "index" },
                                   { :ministry_role_id => 13, :controller => "prcs", :action => "index" },
                                   { :ministry_role_id => 1,  :controller => "prcs", :action => "edit" },
                                   { :ministry_role_id => 13, :controller => "prcs", :action => "edit" }]

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
