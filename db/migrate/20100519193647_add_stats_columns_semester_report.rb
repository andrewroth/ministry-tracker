class AddStatsColumnsSemesterReport < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_totalSpMultGradNonMinistry, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalFullTimeC4cStaff, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalFullTimeP2cStaffNonC4c, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalPeopleOneYearInternship, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalPeopleOtherMinistry, :integer, :default => 0
  end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_totalSpMultGradNonMinistry
    remove_column SemesterReport.table_name, :semesterreport_totalFullTimeC4cStaff
    remove_column SemesterReport.table_name, :semesterreport_totalFullTimeP2cStaffNonC4c
    remove_column SemesterReport.table_name, :semesterreport_totalPeopleOneYearInternship
    remove_column SemesterReport.table_name, :semesterreport_totalPeopleOtherMinistry
  end
end
