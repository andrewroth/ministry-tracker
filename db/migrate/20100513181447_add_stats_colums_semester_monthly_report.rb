class AddStatsColumsSemesterMonthlyReport < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_eventSpirConversations, :integer
    add_column SemesterReport.table_name, :semesterreport_eventGospPres, :integer
    add_column SemesterReport.table_name, :semesterreport_mediaSpirConversations, :integer
    add_column SemesterReport.table_name, :semesterreport_mediaGospPres, :integer
    add_column SemesterReport.table_name, :semesterreport_totalCoreStudents, :integer
    add_column SemesterReport.table_name, :semesterreport_totalStudentInDG, :integer
    add_column SemesterReport.table_name, :semesterreport_totalSpMult, :integer
 end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_eventSpirConversations
    remove_column SemesterReport.table_name, :semesterreport_eventGospPres
    remove_column SemesterReport.table_name, :semesterreport_mediaSpirConversations
    remove_column SemesterReport.table_name, :semesterreport_mediaGospPres
    remove_column SemesterReport.table_name, :semesterreport_totalCoreStudents
    remove_column SemesterReport.table_name, :semesterreport_totalStudentInDG
    remove_column SemesterReport.table_name, :semesterreport_totalSpMult
  end
end
