class CreateRecruitmentPermissions < ActiveRecord::Migration
    NEW_PERMISSIONS = [{ :description => "Recruitment update", :controller => "recruitments", :action => "update" },
                       { :description => "Recruitment edit", :controller => "recruitments", :action => "edit" },
                       { :description => "Recruitment show", :controller => "recruitments", :action => "show" },
                       { :description => "Recruitment new", :controller => "recruitments", :action => "new" },
                       { :description => "Recruitment create", :controller => "recruitments", :action => "create" }
                       ]

    NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 },
                                     { :ministry_role_name => "Team Leader",  :permission_index => 0 },
                                     { :ministry_role_name => "Ministry Leader",  :permission_index => 0 },

                                     { :ministry_role_name => "Team Member",  :permission_index => 1 },
                                     { :ministry_role_name => "Team Leader",  :permission_index => 1 },
                                     { :ministry_role_name => "Ministry Leader",  :permission_index => 1 },

                                     { :ministry_role_name => "Team Member",  :permission_index => 2 },
                                     { :ministry_role_name => "Team Leader",  :permission_index => 2 },
                                     { :ministry_role_name => "Ministry Leader",  :permission_index => 2 },

                                     { :ministry_role_name => "Team Member",  :permission_index => 3 },
                                     { :ministry_role_name => "Team Leader",  :permission_index => 3 },
                                     { :ministry_role_name => "Ministry Leader",  :permission_index => 3 },

                                     { :ministry_role_name => "Team Member",  :permission_index => 4 },
                                     { :ministry_role_name => "Team Leader",  :permission_index => 4 },
                                     { :ministry_role_name => "Ministry Leader",  :permission_index => 4 }
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
