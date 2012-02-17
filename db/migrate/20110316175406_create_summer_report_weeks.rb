class CreateSummerReportWeeks < ActiveRecord::Migration
  def self.up
    create_table SummerReportWeek.table_name do |t|
      t.integer :summer_report_id
      t.integer :week_id
      t.integer :summer_report_assignment_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table SummerReportWeek.table_name
  end
end
