class AddIndexToCampus < ActiveRecord::Migration
  def self.up
    add_index :campuses, :name
  end

  def self.down
    remove_index :campuses, :name
  end
end
