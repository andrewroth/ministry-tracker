class AddSummitWcProjectsToSemesterStats < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_studentsSummit, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_studentsWC, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_studentsProjects, :integer, :default => 0
  end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_studentsSummit
    remove_column SemesterReport.table_name, :semesterreport_studentsWC
    remove_column SemesterReport.table_name, :semesterreport_studentsProjects
  end
end
