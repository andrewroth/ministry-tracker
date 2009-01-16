class DropUserGroups < ActiveRecord::Migration
  def self.up
    create_table "ministry_role_permissions", :force => true do |t|
      t.integer "permission_id"
      t.integer "ministry_role_id"
      t.string  "created_at"
    end
    remove_column :permissions, :name
    add_column :permissions, :controller, :string
    add_column :permissions, :action, :string
  end

  def self.down
    
    drop_table :ministry_role_permissions
    remove_column :permissions, :action
    remove_column :permissions, :controller
    add_column :permissions, :name, :string
  end
end
