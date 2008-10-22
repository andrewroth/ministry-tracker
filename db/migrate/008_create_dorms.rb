class CreateDorms < ActiveRecord::Migration
  def self.up
    create_table :dorms do |t|
      t.column :campus_id, :integer
      t.column :name, :string
      t.column :created_at, :date
    end
    add_index :dorms, :campus_id
  end

  def self.down
    remove_index :table_name, :column_name
    drop_table :dorms
  end
end
