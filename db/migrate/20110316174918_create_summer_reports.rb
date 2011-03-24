class CreateSummerReports < ActiveRecord::Migration
  def self.up
    create_table SummerReport.table_name do |t|
      t.integer :person_id
      t.integer :year_id
      t.string :joined_staff
      t.string :days_of_holiday
      t.string :monthly_goal
      t.string :monthly_have
      t.string :monthly_needed
      t.integer :num_weeks_of_mpd
      t.integer :num_weeks_of_mpm
      t.boolean :support_coach
      t.string :accountability_partner
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table SummerReport.table_name
  end
end
