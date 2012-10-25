class AddNewMonthlyReportColumnsToSemesterAndAnnual < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_lnz_ministering_disciples, :integer, :default => 0
    add_column AnnualReport.table_name,   :annualReport_lnz_ministering_disciples, :integer, :default => 0
  end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_lnz_ministering_disciples
    remove_column AnnualReport.table_name,   :annualReport_lnz_ministering_disciples
  end
end
