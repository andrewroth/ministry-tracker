class AddMonthlyReportColumnsMinisteringDisciples < ActiveRecord::Migration
  def self.up
    add_column MonthlyReport.table_name, :monthlyreport_ministering_disciples, :integer
  end

  def self.down
    remove_column MonthlyReport.table_name, :monthlyreport_ministering_disciples
  end
end
