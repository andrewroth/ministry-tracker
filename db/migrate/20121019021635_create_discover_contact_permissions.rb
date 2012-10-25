class CreateDiscoverContactPermissions < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Discover contacts index", :controller => "discover_contacts", :action => "index" },
                     { :description => "Discover contacts new", :controller => "discover_contacts", :action => "new" },
                     { :description => "Discover contacts show", :controller => "discover_contacts", :action => "show" },
                     { :description => "Discover contacts edit", :controller => "discover_contacts", :action => "edit" },
                     { :description => "Discover contacts create", :controller => "discover_contacts", :action => "create" },
                     { :description => "Discover contacts update", :controller => "discover_contacts", :action => "update" },

                     { :description => "New Note", :controller => "notes", :action => "new" },
                     { :description => "Create Note", :controller => "notes", :action => "create" },
                     { :description => "Create Activity", :controller => "activities", :action => "create" },
                     { :description => "New Activity", :controller => "activities", :action => "new" }
                     ]
                     
  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 0 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Student",  :permission_index => 0 },

                                   { :ministry_role_name => "Team Member",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 1 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 1 },
                                   { :ministry_role_name => "Student",  :permission_index => 1 },

                                   { :ministry_role_name => "Team Member",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 2 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 2 },
                                   { :ministry_role_name => "Student",  :permission_index => 2 },

                                   { :ministry_role_name => "Team Member",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 3 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 3 },
                                   { :ministry_role_name => "Student",  :permission_index => 3 },

                                   { :ministry_role_name => "Team Member",  :permission_index => 4 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 4 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 4 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 4 },
                                   { :ministry_role_name => "Student",  :permission_index => 4 },

                                   { :ministry_role_name => "Team Member",  :permission_index => 5 }, 
                                   { :ministry_role_name => "Team Leader",  :permission_index => 5 }, 
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 5 }, 
                                   { :ministry_role_name => "Student Leader",  :permission_index => 5 },
                                   { :ministry_role_name => "Student",  :permission_index => 5 },

                                   { :ministry_role_name => "Student",  :permission_index => 6 },
                                   { :ministry_role_name => "Student",  :permission_index => 7 },
                                   { :ministry_role_name => "Student",  :permission_index => 8 },
                                   { :ministry_role_name => "Student",  :permission_index => 9 }
                                   ]

  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end

  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?
    end

    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr_id = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } ).id
      permission_id = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } ).id
      MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr_id })
    end
  end

  def self.down
    NEW_MINISTRY_ROLE_PERMISSIONS.each do |mrp|
      p = NEW_PERMISSIONS[mrp[:permission_index]]
      mr = MinistryRole.find(:first, :conditions => { :name => mrp[:ministry_role_name] } )
      perm = Permission.find(:first, :conditions => { :controller => p[:controller], :action => p[:action] } )
      unless mr.nil? || perm.nil?
        mrp = MinistryRolePermission.find(:first, :conditions => { :permission_id => perm.id, :ministry_role_id => mr.id })
        mrp.destroy unless mrp.nil?
      end
    end

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)
      p.destroy unless p.nil?
    end
  end
end
