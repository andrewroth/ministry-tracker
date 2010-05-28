class AddP2cColumnsToMonthlyReportTable < ActiveRecord::Migration
  def self.up
    add_column MonthlyReport.table_name, :montlyreport_p2c_numInEvangStudies, :integer, :default => 0
    add_column MonthlyReport.table_name, :montlyreport_p2c_numTrainedToShareInP2c, :integer, :default => 0
    add_column MonthlyReport.table_name, :montlyreport_p2c_numTrainedToShareOutP2c, :integer, :default => 0
    add_column MonthlyReport.table_name, :montlyreport_p2c_numSharingInP2c, :integer, :default => 0
    add_column MonthlyReport.table_name, :montlyreport_p2c_numSharingOutP2c, :integer, :default => 0
    add_column MonthlyReport.table_name, :montlyreport_p2c_numCommitFilledHS, :integer, :default => 0
  end

  def self.down
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numInEvangStudies
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numTrainedToShareInP2c
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numTrainedToShareOutP2c
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numSharingInP2c
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numSharingOutP2c
    remove_column MonthlyReport.table_name, :montlyreport_p2c_numCommitFilledHS
  end
end
