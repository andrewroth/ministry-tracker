class CreateSummerReportSummerDefinitions < ActiveRecord::Migration
  def self.up
    create_table SummerReportSummerDefinition.table_name do |t|
      t.integer :year_id
      t.integer :first_week_id
      t.integer :last_week_id

      t.timestamps
    end
  end

  def self.down
    drop_table SummerReportSummerDefinition.table_name
  end
end
