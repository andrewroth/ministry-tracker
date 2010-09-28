class AddSearchPermission < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Search using the top search bar", :controller => "search", :action => "index" },
                     { :description => "Return people in search results", :controller => "search", :action => "return_people" },
                     { :description => "Return groups in search results", :controller => "search", :action => "return_groups" }
                    ]

  NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Staff",  :permission_index => 0 },
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Student Leader",  :permission_index => 0 },
                                   { :ministry_role_name => "Involved Student",  :permission_index => 0 },
                                   { :ministry_role_name => "Team Member",  :permission_index => 0 },

                                   { :ministry_role_name => "Team Leader",  :permission_index => 1 },
                                   { :ministry_role_name => "Staff",  :permission_index => 1 },
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 1 },
                                   { :ministry_role_name => "Student Leader",  :permission_index => 1 },
                                   { :ministry_role_name => "Involved Student",  :permission_index => 1 },
                                   { :ministry_role_name => "Team Member",  :permission_index => 1 },

                                   { :ministry_role_name => "Team Leader",  :permission_index => 2 },
                                   { :ministry_role_name => "Staff",  :permission_index => 2 },
                                   { :ministry_role_name => "Ministry Leader",  :permission_index => 2 },
                                   { :ministry_role_name => "Student Leader",  :permission_index => 2 },
                                   { :ministry_role_name => "Involved Student",  :permission_index => 2 },
                                   { :ministry_role_name => "Team Member",  :permission_index => 2 }
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
      if permission_id.present? && mr_id.present?
        MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr_id })
      end
    end
  end

  def self.down
    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)

      unless p.nil?
        mrps = MinistryRolePermission.all(:conditions => { :permission_id => p.id })
        mrps.each do |mrp|
          mrp.destroy unless mrp.nil?
        end

        p.destroy
      end
    end
  end
end
