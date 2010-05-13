class MergeNewSemesterMonthlyColumnsData < ActiveRecord::Migration
  def self.up
    SemesterReport.all.each do | sr |
      sr[:semesterreport_eventSpirConversations] = 0
      sr[:semesterreport_eventGospPres] = 0
      sr[:semesterreport_mediaSpirConversations] = 0
      sr[:semesterreport_mediaGospPres] = 0
      sr[:semesterreport_totalCoreStudents] = 0
      sr[:semesterreport_totalStudentInDG] = sr[:semesterreport_numInStaffDG] + sr[:semesterreport_numInStudentDG]
      sr[:semesterreport_totalSpMult] = sr[:semesterreport_numSpMultStaffDG] + sr[:semesterreport_numSpMultStdDG]
      sr.save!
    end
  end

  def self.down
  end
end
