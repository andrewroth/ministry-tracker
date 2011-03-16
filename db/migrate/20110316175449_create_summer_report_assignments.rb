class CreateSummerReportAssignments < ActiveRecord::Migration
  def self.up
    create_table SummerReportAssignment.table_name do |t|
      t.string :assignment

      t.timestamps
    end
  end

  def self.down
    drop_table SummerReportAssignment.table_name
  end
end
