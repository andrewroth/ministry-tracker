class CreateSummerReportReviewers < ActiveRecord::Migration
  def self.up
    create_table SummerReportReviewer.table_name do |t|
      t.integer :summer_report_id
      t.integer :person_id
      t.boolean :reviewed
      t.boolean :approved
      t.text :review_notes

      t.timestamps
    end
  end

  def self.down
    drop_table SummerReportReviewer.table_name
  end
end
