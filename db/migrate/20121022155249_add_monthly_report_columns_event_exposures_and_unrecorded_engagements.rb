class AddMonthlyReportColumnsEventExposuresAndUnrecordedEngagements < ActiveRecord::Migration
  def self.up
    add_column MonthlyReport.table_name, :monthlyreport_event_exposures, :integer
    add_column MonthlyReport.table_name, :monthlyreport_unrecorded_engagements, :integer
  end

  def self.down
    remove_column MonthlyReport.table_name, :monthlyreport_event_exposures
    remove_column MonthlyReport.table_name, :monthlyreport_unrecorded_engagements
  end
end
