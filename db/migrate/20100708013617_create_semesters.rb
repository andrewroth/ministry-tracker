class CreateSemesters < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      t.integer :year_id
      t.date :start_date
      t.string :desc

      t.timestamps
    end
    add_index :semesters, :year_id
    add_index :semesters, :start_date
  end

  def self.down
    remove_index :semesters, :year_id
    remove_index :semesters, :start_date
    drop_table :semesters
  end
end
