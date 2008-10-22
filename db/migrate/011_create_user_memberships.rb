class CreateUserMemberships < ActiveRecord::Migration
  def self.up
    create_table :user_memberships do |t|
      t.column :user_id, :integer
      t.column :user_group_id, :integer
      t.column :created_at, :date
    end
    add_index :user_memberships, [:user_id, :user_group_id], :unique => true
  end

  def self.down
    remove_index :user_memberships, :column => :user_id
    drop_table :user_memberships
  end
end
