class AddFacebookUsernameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_username, :string
  end

  def self.down
    remove_column :users, :facebook_username
  end
end
