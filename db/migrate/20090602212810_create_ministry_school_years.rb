class CreateMinistrySchoolYears < ActiveRecord::Migration
  def self.up
    create_table :ministry_school_years do |t|
      t.integer :ministry_id
      t.date :create_next_year_at
      t.date :start
      t.date :end

      t.timestamps
    end
  end

  def self.down
    drop_table :ministry_school_years
  end
end
