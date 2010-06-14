class RemoveStatsColumnsSemesterMonthlyReport < ActiveRecord::Migration
  def self.up
    remove_column SemesterReport.table_name, :semesterreport_eventSpirConversations
    remove_column SemesterReport.table_name, :semesterreport_eventGospPres
    remove_column SemesterReport.table_name, :semesterreport_mediaSpirConversations
    remove_column SemesterReport.table_name, :semesterreport_mediaGospPres
    remove_column SemesterReport.table_name, :semesterreport_totalCoreStudents
    remove_column SemesterReport.table_name, :semesterreport_totalStudentInDG
    remove_column SemesterReport.table_name, :semesterreport_totalSpMult
    remove_column SemesterReport.table_name, :month_id
  end

  def self.down
    add_column SemesterReport.table_name, :semesterreport_eventSpirConversations, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_eventGospPres, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_mediaSpirConversations, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_mediaGospPres, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalCoreStudents, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalStudentInDG, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_totalSpMult, :integer, :default => 0
    add_column SemesterReport.table_name, :month_id, :integer, :limit => 4
  end
end
