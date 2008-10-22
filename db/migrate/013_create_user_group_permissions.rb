class CreateUserGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :user_group_permissions do |t|
      t.column :permission_id, :integer
      t.column :user_group_id, :integer
      t.column :created_at, :string
    end
    add_index :user_group_permissions, [:permission_id, :user_group_id], :unique => true
  end

  def self.down
    remove_index :user_group_permissions, :column => :permission_id
    drop_table :user_group_permissions
  end
end
