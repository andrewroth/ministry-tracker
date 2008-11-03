class CreateDevelopers < ActiveRecord::Migration
  def self.up
    add_column :users, :developer, :boolean
  end

  def self.down
    remove_column :users, :developer
  end
end
