class AddStateIdIndexToCampus < ActiveRecord::Migration
  def self.up
    add_index :campuses, :state_id
    add_index :campuses, :name
  end

  def self.down
    remove_index :campuses, :name
    remove_index :campuses, :state_id
    mind
  end
end
