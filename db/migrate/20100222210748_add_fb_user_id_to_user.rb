class AddFbUserIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_user_id, :integer, :limit => 20

  end

  def self.down
    remove_column :users, :fb_user_id
  end
end
