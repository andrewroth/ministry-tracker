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
        {:column => :total_graduating_students_to_non_ministry, 
         :label => "Total spiritual multipliers graduating to non-ministry vocations"}, 
        {:column => :total_graduating_students_to_full_time_c4c_staff, 
         :label => "Total full time C4C staff"}, 
        {:column => :total_graduating_students_to_full_time_p2c_non_c4c, 
         :label => "Total full time P2C staff (non-campus)"}, 
        {:column => :total_graduating_students_to_one_year_internship, 
         :label => "Total people doing one-year internships"}, 
        {:column => :total_graduating_students_to_other_ministry, 
         :label => "Total people doing other full time ministry"}
      ], 
        :weekly_report => [
         {:column => :spiritual_conversations, 
         :label => "Spiritual Conversations:"}, 
        {:column => :spiritual_conversations_student, 
         :label => "Spiritual Conversations by Disciples:"}, 
        {:column => :gospel_presentations, 
         :label => "Gospel Presentations:"}, 
        {:column => :gospel_presentations_student, 
         :label => "Gospel Presentations by Disciples:"}, 
        {:column => :holyspirit_presentations, 
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
