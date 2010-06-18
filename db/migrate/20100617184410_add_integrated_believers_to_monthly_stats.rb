class AddIntegratedBelieversToMonthlyStats < ActiveRecord::Migration
  def self.up
    add_column MonthlyReport.table_name, :montlyreport_integratedNewBelievers, :integer, :default => 0
  end

  def self.down
    remove_column MonthlyReport.table_name, :montlyreport_integratedNewBelievers
  end
end
