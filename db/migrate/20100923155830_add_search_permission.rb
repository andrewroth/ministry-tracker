class AddSearchPermission < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "Search using the top search bar", :controller => "search", :action => "index" }]

  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end

  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?

      MinistryRole.all.each do |mr|
        permission_id = find_permission(permission).id
        MinistryRolePermission.create!({ :permission_id => permission_id, :ministry_role_id => mr.id })
      end
    end

  end

  def self.down

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)

      unless p.nil?
        MinistryRole.all.each do |mr|
          mrp = MinistryRolePermission.find(:first, :conditions => { :permission_id => p.id, :ministry_role_id => mr.id })
          mrp.destroy unless mrp.nil?
        end

        p.destroy
      end

    end

  end
end
