class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table Semester.table_name do |t|
      t.integer :year_id
      t.date :start_date
      t.string :desc

      t.timestamps
    end
    add_index Semester.table_name, :year_id
    add_index Semester.table_name, :start_date
  end

  def self.down
    remove_index Semester.table_name, :year_id
    remove_index Semester.table_name, :start_date
    drop_table Semester.table_name
  end
end
