class HsCommitmentsToBeCollectedMonthly < ActiveRecord::Migration
  def self.up
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numCommitFilledHS
    add_column WeeklyReport.table_name, :weeklyReport_p2c_numCommitFilledHS, :integer, :default => 0
  end

  def self.down
    add_column MonthlyReport.table_name, :montlyreport_p2c_numCommitFilledHS, :integer, :default => 0
    remove_column WeeklyReport.table_name, :weeklyReport_p2c_numCommitFilledHS
  end
end
