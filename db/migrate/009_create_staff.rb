class CreateStaff < ActiveRecord::Migration
  def self.up
    create_table :staff do |t|
      t.column :ministry_id, :integer
      t.column :person_id, :integer
      t.column :created_at, :date
    end
    add_index :staff, :ministry_id
  end

  def self.down
    remove_index :staff, :ministry_id
    drop_table :staff
  end
end
