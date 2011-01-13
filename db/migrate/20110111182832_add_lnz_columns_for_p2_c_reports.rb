class AddLnzColumnsForP2CReports < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_lnz_p2c_numInEvangStudies, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_p2c_numSharingInP2c, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_p2c_numSharingOutP2c, :integer, :default => 0

    add_column AnnualReport.table_name, :annualreport_lnz_p2c_numInEvangStudies, :integer, :default => 0
    add_column AnnualReport.table_name, :annualreport_lnz_p2c_numSharingInP2c, :integer, :default => 0
    add_column AnnualReport.table_name, :annualreport_lnz_p2c_numSharingOutP2c, :integer, :default => 0
  end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_lnz_p2c_numInEvangStudies
    remove_column SemesterReport.table_name, :semesterreport_lnz_p2c_numSharingInP2c
    remove_column SemesterReport.table_name, :semesterreport_lnz_p2c_numSharingOutP2c

    remove_column AnnualReport.table_name, :annualreport_lnz_p2c_numInEvangStudies
    remove_column AnnualReport.table_name, :annualreport_lnz_p2c_numSharingInP2c
    remove_column AnnualReport.table_name, :annualreport_lnz_p2c_numSharingOutP2c
  end
end
