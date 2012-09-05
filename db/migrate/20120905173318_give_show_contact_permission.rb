class GiveShowContactPermission < ActiveRecord::Migration
  NEW_PERMISSIONS = [{ :description => "Show Contact", :controller => "contacts", :action => "show" }
                     ]
                     
   NEW_MINISTRY_ROLE_PERMISSIONS = [{ :ministry_role_name => "Team Member",  :permission_index => 0 }, 
                                    { :ministry_role_name => "Team Leader",  :permission_index => 0 }, 
                                    { :ministry_role_name => "Ministry Leader",  :permission_index => 0 }, 
                                    { :ministry_role_name => "Student Leader",  :permission_index => 0 }]

   def self.up
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
   end
end
