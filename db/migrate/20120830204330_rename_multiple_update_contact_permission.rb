class RenameMultipleUpdateContactPermission < ActiveRecord::Migration
  def self.up
    p = Permission.find(:first, :conditions => { :controller => 'contacts', :action => 'multiple_assign' } )
    p.action = 'multiple_update'
    p.description = 'Batch Update Contacts'
    p.save
  end

  def self.down
    p = Permission.find(:first, :conditions => { :controller => 'contacts', :action => 'multiple_update' } )
    p.action = 'multiple_assign'
    p.description = 'Batch Edit Contact Assignment'
    p.save
  end
end