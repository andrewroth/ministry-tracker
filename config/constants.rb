  def oa_region
    1
  end
  
  def west_region
    3
  end
  
  def quebec_region
    2
  end
  
  def national_region
    4
  end
  
  def gos_pres
    :weeklyReport_1on1GosPres
  end
  
  def gos_pres_std
    :weeklyReport_1on1GosPresStd
  end
  
  def sp_conv
    :weeklyReport_1on1SpConv
  end
  
  def sp_conv_std
    :weeklyReport_1on1SpConvStd
  end
  
  def hs_pres
    :weeklyReport_1on1HsPres
  end
  
  def permission_national
    45
  end
  
  def permission_regional
    44
  end
  
  def permission_campusdirector
    43
  end
  
  def permission_statscoordinator
    42
  end
  
  def permission_allstaff
    41
  end
  
  def stats_reports
      {:semester_report => [
        {:column => :semesterreport_totalSpMultGradNonMinistry, 
         :label => "Total spiritual multipliers graduating to non-ministry vocations"}, 
        {:column => :semesterreport_totalFullTimeC4cStaff, 
         :label => "Total full time C4C staff"}, 
        {:column => :semesterreport_totalFullTimeP2cStaffNonC4c, 
         :label => "Total full time P2C staff (non-campus)"}, 
        {:column => :semesterreport_totalPeopleOneYearInternship, 
         :label => "Total people doing one-year internships"}, 
        {:column => :semesterreport_totalPeopleOtherMinistry, 
         :label => "Total people doing other full time ministry"}
      ], 
        :weekly_report => [
         {:column => :weeklyReport_1on1SpConv, 
         :label => "Spiritual Conversations:"}, 
        {:column => :weeklyReport_1on1SpConvStd, 
         :label => "Spiritual Conversations by Disciples:"}, 
        {:column => :weeklyReport_1on1GosPres, 
         :label => "Gospel Presentations:"}, 
        {:column => :weeklyReport_1on1GosPresStd, 
         :label => "Gospel Presentations by Disciples:"}, 
        {:column => :weeklyReport_1on1HsPres, 
         :label => "Holy Spirit Presentations:"}
      ], 
        :monthly_report => [
        {:column => :average_hours_prayer, 
         :label => "Average - hours of prayer:"}, 
        {:column => :number_frosh_involved, 
         :label => "Number of frosh involved:"},
        {:column => :total_students_in_dg, 
         :label => "Number of students in DGs:"},
        {:column => :total_spiritual_multipliers, 
         :label => "Number of spiritual multipliers:"},
        {:column => :event_spiritual_conversations, 
         :label => "Event exposures - Spiritual Conversations:"},
        {:column => :event_gospel_prensentations, 
         :label => "Event exposures - Gospel Presentations:"},
        {:column => :media_spiritual_conversations, 
         :label => "Media exposures - Spiritual Conversations:"},
        {:column => :media_gospel_prensentations, 
         :label => "Media exposures - Gospel Presentations:"},
        {:column => :total_core_students, 
         :label => "Total core students:"}
      ]}
end
