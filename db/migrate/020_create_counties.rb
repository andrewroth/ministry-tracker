class CreateCounties < ActiveRecord::Migration
  def self.up
    create_table :counties do |t|
      t.column :name, :string
      t.column :state, :string
    end
    add_index :counties, :state
    add_index :campuses, :county
  end

  def self.down
    remove_index :counties, :state
    drop_table :counties
    remove_index :campuses, :county
  end
end
