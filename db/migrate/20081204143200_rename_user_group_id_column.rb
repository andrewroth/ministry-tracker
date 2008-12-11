class RenameUserGroupIdColumn < ActiveRecord::Migration
  def self.up
    rename_column :ministry_role_permissions, :user_group_id, :ministry_role_id
    # Create default permission set
    Permission.create(:action => 'edit', :controller => 'groups', :description => 'Edit groups (bible studies, teams, etc)')
    Permission.create(:action => 'new', :controller => 'groups', :description => 'Create groups (bible studies, teams, etc)')
    Permission.create(:action => 'new', :controller => 'people', :description => 'Add new people')
    Permission.create(:action => 'new', :controller => 'imports', :description => 'Bulk import people')
    Permission.create(:action => 'new', :controller => 'ministries', :description => 'Create new Ministries')
    Permission.create(:action => 'edit', :controller => 'ministry_roles', :description => 'Edit Ministry Roles')
    Permission.create(:action => 'new', :controller => 'ministry_roles', :description => 'Create Ministry Roles')
    Permission.create(:action => 'new', :controller => 'involvement_questions', :description => 'Create Involvement Questions')
    Permission.create(:action => 'new', :controller => 'training_questions', :description => 'Create Training Questions')
    Permission.create(:action => 'new', :controller => 'views', :description => 'Create Directory Views')
    Permission.create(:action => 'new', :controller => 'custom_attributes', :description => 'Create Custom Attributes')
    Permission.create(:action => 'edit', :controller => 'ministries', :description => 'Edit Existing Ministries')
  end

  def self.down
    rename_column :ministry_role_permissions, :ministry_role_id, :user_group_id
    Permission.delete_all
  end
end
