class CreateCampusInvolvements < ActiveRecord::Migration
  def self.up
    create_table :campus_involvements do |t|
      t.column :person_id, :integer
      t.column :campus_id, :integer
      t.column :ministry_role_id, :integer
      t.column :start_date, :date
      t.column :end_date, :date
    end
    add_index :campus_involvements, [:person_id, :campus_id], :unique => true
  end

  def self.down
    remove_index :table_name, :column => :column_name
    drop_table :campus_involvements
  end
end
