class AddLnzColumnsToSemesterStats < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :semesterreport_lnz_avgPrayer, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_numFrosh, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_totalStudentInDG, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_totalSpMult, :integer, :default => 0
    add_column SemesterReport.table_name, :semesterreport_lnz_totalCoreStudents, :integer, :default => 0
  end

  def self.down
    remove_column SemesterReport.table_name, :semesterreport_lnz_avgPrayer
    remove_column SemesterReport.table_name, :semesterreport_lnz_numFrosh
    remove_column SemesterReport.table_name, :semesterreport_lnz_totalStudentInDG
    remove_column SemesterReport.table_name, :semesterreport_lnz_totalSpMult
    remove_column SemesterReport.table_name, :semesterreport_lnz_totalCoreStudents
  end
end
