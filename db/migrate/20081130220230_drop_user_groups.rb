class DropUserGroups < ActiveRecord::Migration
  def self.up
    drop_table :user_groups
    rename_table :user_group_permissions, :ministry_role_permissions
    remove_column :permissions, :name
    add_column :permissions, :controller, :string
    add_column :permissions, :action, :string
    drop_table :user_memberships
  end

  def self.down
    create_table "user_memberships", :force => true do |t|
      t.integer "user_id"
      t.integer "user_group_id"
      t.date    "created_at"
    end
    
    remove_column :permissions, :action
    remove_column :permissions, :controller
    add_column :permissions, :name, :string
    rename_table :ministry_role_permissions, :user_group_permissions
    create_table "user_groups", :force => true do |t|
      t.string  "name"
      t.date    "created_at"
      t.integer "ministry_id"
    end
    
  end
end
