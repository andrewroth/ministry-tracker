class AddDefaultViewColumn < ActiveRecord::Migration
  def self.up
    add_column :views, :default, :boolean
  end

  def self.down
    remove_column :views, :default
  end
end
