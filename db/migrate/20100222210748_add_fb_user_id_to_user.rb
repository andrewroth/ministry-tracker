class AddFbUserIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_user_id, :bigint
    add_index :users, :fb_user_id
  end

  def self.down
    remove_index :users, :fb_user_id
    remove_column :users, :fb_user_id
  end
end
