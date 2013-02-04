class AddContactsPermissions < ActiveRecord::Migration
 NEW_PERMISSIONS = [{ :description => "View Contact List", :controller => "contacts", :action => "index" },
                    { :description => "Edit Contact", :controller => "contacts", :action => "edit" },
                    { :description => "Save Contact", :controller => "contacts", :action => "save" },
                    { :description => "Batch Edit Contact Assignement", :controller => "contacts", :action => "multiple_assign" },
                    { :description => "Search Contacts", :controller => "contacts", :action => "search" }]

  def self.find_permission(permission)
    Permission.find(:first, :conditions => { :controller => permission[:controller], :action => permission[:action] } )
  end
  
  def self.up
    NEW_PERMISSIONS.each do |permission|
      Permission.create!(permission) if find_permission(permission).nil?
    end
  end

  def self.down

    NEW_PERMISSIONS.each do |permission|
      p = find_permission(permission)
      p.destroy unless p.nil?
    end

  end
end
