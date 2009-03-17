class AddIndexesToPerson < ActiveRecord::Migration
  def self.up
    add_index :people, [:last_name, :first_name]
    add_index :people, :first_name
    add_index :people, [:major, :minor]
  end

  def self.down
    remove_index :people, [:major, :minor]
    remove_index :people, [:last_name, :first_name]
    remove_index :people, :last_name
    mind
  end
end
