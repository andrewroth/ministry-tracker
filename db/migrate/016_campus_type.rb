class CampusType < ActiveRecord::Migration
  def self.up
    add_column :campuses, :type, :string
  end

  def self.down
    remove_column :campuses, :type
  end
end
