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
  
  def report_types
    { 
      :c4c => {:order => 1, :label => "Campus for Christ Reports", :controller => :stats, :action => :index, :scopes => [:summary, :campus_drill_down, :staff_drill_down]},
      :p2c => {:order => 5, :label => "Power to Change Reports", :controller => :stats, :action => :show_p2c_report, :scopes => [:summary]},
      :ccci => {:order => 6, :label => "CCCI Reports", :controller => :stats, :action => :show_ccci_report, :scopes => [:summary, :campus_drill_down]},
      :comp => {:order => 4, :label => "Compliance Reports", :controller => :stats, :action => :show_compliance_report, :scopes => [:staff_drill_down]},
      :hpctc => {:order => 2, :label => "How people came to Christ", :controller => :stats, :action => :how_people_came_to_christ, :scopes => [:summary]},
      :story => {:order => 3, :label => "Salvation Story Synopses", :controller => :stats, :action => :salvation_story_synopses, :scopes => [:summary]}
    }
  end
  
  def report_scopes
    {
      :summary => {
                    :order => 1, 
                    :label => "Summary", 
                    :title => "See a summary of all the campuses under [MINISTRY_NAME]",
                    :radio_id => "report_scope_summary",
                    :show => :yes
      },
      :campus_drill_down => {
                    :order => 2,
                    :label => "Campus drill-down", 
                    :title => "See individual campuses under [MINISTRY_NAME]",
                    :radio_id => "report_scope_campus_drill_down",
                    :show => :yes
      },
      :staff_drill_down => {
                    :order => 3,
                    :label => "Staff drill-down", 
                    :title => "See individual staff members under [MINISTRY_NAME]",
                    :radio_id => "report_scope_staff_drill_down",
                    :show => :yes
      }
    }
  end
  
  def report_permissions
    {
      :semester_report => {
       :editing => {:controller => :semester_report, :action => :new},
       :reading => {:controller => :stats, :action => :semester_highlights}
      }, 
      :weekly_report => {
       :editing => {:controller => :weekly_report, :action => :new},
       :reading => {:controller => :stats, :action => :index}
      }, 
      :indicated_decisions_report => {
       :reading => {:controller => :stats, :action => :index}
      }, 
      :monthly_report => {
       :editing => {:controller => :monthly_report, :action => :new},
       :reading => {:controller => :stats, :action => :monthly_report}
      }, 
      :monthly_p2c_special => {
       :editing => {:controller => :monthly_report, :action => :new},
      }, 
      :ccci_report => {
       :reading => {:controller => :stats, :action => :show_ccci_report}
      },
      :p2c_report => {
       :reading => {:controller => :stats, :action => :show_p2c_report}
      },
      :annual_goals_report => {
       :editing => {:controller => :annual_goals_report, :action => :new},
       #:reading => {:controller => :stats, :action => :annual_goals_recap}
      }      
    }
  end
  
  def stats_reports
      {:semester_report => {
          :tot_grad_non_ministry => {:column => :semesterreport_totalSpMultGradNonMinistry, 
           :label => "Total spiritual multipliers graduating to non-ministry vocations",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 1}, 
          :tot_grad_c4c_staff => {:column => :semesterreport_totalFullTimeC4cStaff, 
           :label => "Total full time C4C staff",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 2}, 
          :tot_grad_p2c_staff => {:column => :semesterreport_totalFullTimeP2cStaffNonC4c, 
           :label => "Total full time P2C staff (non-campus)",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 3}, 
          :tot_grad_intern => {:column => :semesterreport_totalPeopleOneYearInternship, 
           :label => "Total people doing one-year internships",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 4}, 
          :tot_grad_other_ministry => {:column => :semesterreport_totalPeopleOtherMinistry, 
           :label => "Total people doing other full time ministry",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 5}, 
          :students_attending_summit => {:column => :semesterreport_studentsSummit, 
           :label => "Students attending Summit",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 6}, 
          :students_going_to_wc => {:column => :semesterreport_studentsWC, 
           :label => "Students going to Winter Conference",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 7}, 
          :students_going_to_projects => {:column => :semesterreport_studentsProjects, 
           :label => "Students going to projects",
            :collected => :semesterly,
            :column_type => :database_column,
            :order => 8}
      }, 
        :weekly_report => {
           :spirit_conversations => {:column => :weeklyReport_1on1SpConv, 
             :label => "Spiritual Conversations:",
             :collected => :weekly,
             :column_type => :database_column,
             :order => 1 
           }, 
           :spirit_conversations_disciples => {
             :column => :weeklyReport_1on1SpConvStd, 
             :label => "Spiritual Conversations by Disciples:",
             :collected => :weekly,
             :column_type => :database_column,
             :order => 2
           }, 
           :spirit_conversations_total => {
             :label => "Spiritual Conversations Total:",
             :collected => :weekly,
             :css_class => " statsTableTotal",
             :column_type => :sum,
             :columns_sum => [{:report => :weekly_report, :line => :spirit_conversations},
                              {:report => :weekly_report, :line => :spirit_conversations_disciples}],
             :order => 3
           }, 
           :gospel_pres => {
             :column => :weeklyReport_1on1GosPres, 
             :label => "Gospel Presentations:",
             :collected => :weekly,
             :column_type => :database_column ,
             :order => 4
           }, 
           :gospel_pres_disciples => {
             :column => :weeklyReport_1on1GosPresStd, 
             :label => "Gospel Presentations by Disciples:",
             :collected => :weekly,
             :column_type => :database_column,
             :order => 5
           }, 
           :gospel_pres_total => {
             :label => "Gospel Presentations Total:",
             :collected => :weekly,
             :css_class => " statsTableTotal",
             :column_type => :sum,
             :columns_sum => [{:report => :weekly_report, :line => :gospel_pres},
                              {:report => :weekly_report, :line => :gospel_pres_disciples}],
             :order => 6
           }, 
           :holy_spirit_pres => {
             :column => :weeklyReport_1on1HsPres, 
             :label => "Holy Spirit Presentations:",
             :collected => :weekly,
             :column_type => :database_column ,
             :order => 7
           }
      },
      :indicated_decisions_report => {
#           :blank_line => {
#             :column_type => :blank_line ,
#             :order => 0
#           },
           :indicated_decisions => {
             :label => "Indicated Decisions:",
             :collected => :prc,
             :column_type => :database_column ,
             :order => 1
           }
        },
        :indicated_decision_report => {
            :campus_id => {
             :column => :campus_id, 
             :label => "Campus:",
             :display_type => :drop_down,
             :drop_down_data => :campus,
             :collected => :prc,           
             :column_type => :database_column ,
             :order => 0
           },         
           :semester_id => {
             :column => :semester_id, 
             :label => "Semester",
             :display_type => :drop_down,
             :drop_down_data => :semester,
             :collected => :prc,           
             :column_type => :database_column ,
             :order => 1
           },
           :decision_date => {
             :column => :prc_date, 
             :label => "Date:",
             :display_type => :date_picker,
             :collected => :prc,           
             :column_type => :database_column ,
             :order => 2
           },       
           :believer_first_name => {
             :column => :prc_firstName, 
             :label => "New believer's first name:",
             :collected => :prc,           
             :column_type => :database_column ,
             :order => 3
           },
           :witness_name => {
             :column => :prc_witnessName, 
             :label => "Witness name:",
             :collected => :prc,
             :column_type => :database_column ,
             :order => 4
           },
           :method => {
             :column => :prcMethod_id, 
             :label => "Method:",
             :display_type => :drop_down,
             :drop_down_data => :prc_method,
             :collected => :prc,
             :column_type => :database_column ,
             :order => 5
           },         
           :integrated_believer => {
             :column => :prc_7upCompleted, 
             :label => "Integrated believer?:",
             :display_type => :checkbox,
             :collected => :prc,
             :column_type => :database_column ,
             :order => 6
           },
           :notes => {
             :column => :prc_notes, 
             :label => "Story:",
             :display_type => :text_area,
             :collected => :prc,
             :column_type => :database_column ,
             :order => 7
           }           
      }, 
        :monthly_report => {
          :avg_hours_prayer => {:column => :monthlyreport_avgPrayer, 
            :label => "Average - hours of prayer:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 1
          }, 
          :frosh => {:column => :monthlyreport_numFrosh, 
            :label => "Number of frosh involved:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 2
          },
          :students_dg => {:column => :monthlyreport_totalStudentInDG, 
            :label => "Number of students in DGs:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 3
          },
          :spirit_mult => {:column => :monthlyreport_totalSpMult, 
            :label => "Number of spiritual multipliers:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 4
          },
          :evt_spirit_conv => {:column => :monthlyreport_eventSpirConversations, 
            :label => "Event exposures - Spiritual Conversations:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 5
          },
          :evt_gos_pres => {:column => :monthlyreport_eventGospPres, 
            :label => "Event exposures - Gospel Presentations:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 6
          },
          :med_spirit_conv => {:column => :monthlyreport_mediaSpirConversations, 
            :label => "Media exposures - Spiritual Conversations:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 7
          },
          :med_gos_pres => {:column => :monthlyreport_mediaGospPres, 
            :label => "Media exposures - Gospel Presentations:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 8
          },
          :core_students => {:column => :monthlyreport_totalCoreStudents, 
            :label => "Total core students:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 9
          },
          :integrated_new_believers => {:column => :montlyreport_integratedNewBelievers, 
            :label => "Integrated new believers:",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 10
          },
          :growth_rate => { 
            :label => "Conversion growth rate:",
            :collected => :monthly,
            :column_type => :division,
            :dividend => {:report => :monthly_report, :line => :integrated_new_believers},
            :divisor => {:report => :monthly_report, :line => :students_dg},
            :order => 11
          }
      },
      :weekly_p2c_special => {
          :commit_filled_hs => {:column => :weeklyReport_p2c_numCommitFilledHS, 
            :label => "Number of commitments to be filled with Holy Spirit or Lordship commitments",
            :collected => :weekly,
            :column_type => :database_column,
            :order => 1
          }
      }, 
        :monthly_p2c_special => {
          :evang_studies => {:column => :montlyreport_p2c_numInEvangStudies, 
            :submit_label => "Number of people in evangelistic studies (i.e. discovery groups or individual sessions)",
            :label => "Number of people in evangelistic studies",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 1
          }, 
          :trained_to_share_in => {:column => :montlyreport_p2c_numTrainedToShareInP2c, 
            :label => "Number of People *trained* to share their faith in the power of the Holy Spirit a. with P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 2
          }, 
          :trained_to_share_out => {:column => :montlyreport_p2c_numTrainedToShareOutP2c, 
            :label => "b. outside P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 3
          }, 
          :sharing_in => {:column => :montlyreport_p2c_numSharingInP2c, 
            :label => "Number of people who are sharing their faith a. with P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 4
          }, 
          :sharing_out => {:column => :montlyreport_p2c_numSharingOutP2c, 
            :label => "b. outside P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :order => 5
          }
      }, 
      :ccci_report => {
        :win_exposures => {
          :label => "1. WIN - EXPOSURES",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :weekly_report, :line => :spirit_conversations_total},
                           {:report => :weekly_report, :line => :gospel_pres_total},
                           {:report => :monthly_report, :line => :evt_gos_pres},
                           {:report => :monthly_report, :line => :med_gos_pres}],
          :order => 1
        },
        :win_decisions => {
          :label => "2. WIN - DECISIONS",
          :collected => :weekly,
          :column_type => :sum,
          :columns_sum => [{:report => :indicated_decisions_report, :line => :indicated_decisions}],
          :order => 2
        },
        :build_growth => {
          :label => "3. BUILD - GROWTH GROUP MEMBERS",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :students_dg}],
          :order => 3
        },
        :build_group_members => {
          :label => "4. BUILD - MOVEMENT (ACTION) GROUP MEMBERS",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :core_students}],
          :order => 4
        },
        :send_group_leaders => {
          :label => "5. SEND - MOVEMENT (ACTION) GROUP LEADERS",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :spirit_mult}],
          :order => 5
        },
        :send_laborers => {
          :label => "6. SEND - LIFETIME LABORERS",
          :collected => :semesterly,
          :column_type => :sum,
          :columns_sum => [{:report => :semester_report, :line => :tot_grad_non_ministry},
                           {:report => :semester_report, :line => :tot_grad_c4c_staff},
                           {:report => :semester_report, :line => :tot_grad_p2c_staff},
                           {:report => :semester_report, :line => :tot_grad_intern},
                           {:report => :semester_report, :line => :tot_grad_other_ministry}],
          :order => 6
        },
        :send_ccci_staff => {
          :label => "7. SEND - FULL-TIME CAMPUS CRUSADE STAFF MEMBERS",
          :collected => :semesterly,
          :column_type => :sum,
          :columns_sum => [{:report => :semester_report, :line => :tot_grad_c4c_staff},
                           {:report => :semester_report, :line => :tot_grad_p2c_staff},
                           {:report => :semester_report, :line => :tot_grad_intern}],
          :order => 7
        }
      },
      :p2c_report => {
        :people_exposed_to_gospel => {
          :label => "1. Number of people exposed to the gospel",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :weekly_report, :line => :spirit_conversations_total},
                           {:report => :weekly_report, :line => :gospel_pres_total},
                           {:report => :monthly_report, :line => :evt_gos_pres},
                           {:report => :monthly_report, :line => :med_gos_pres}],
          :order => 1
        },
        :indicated_decisions => {
          :label => "2. Number of indicated decisions for Christ",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :indicated_decisions_report, :line => :indicated_decisions}],
          :order => 2
        },
        :people_in_studies => {
          :label => "3. Number of people in evangelistic studies (i.e. discovery groups or individual sessions)",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :evang_studies}],
          :order => 3
        },
        :integrated_new_believers => {
          :label => "4. Integrated new believers",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :integrated_new_believers}],
          :order => 4
        },
        :people_in_growth_groups => {
          :label => "5. Number of people in growth groups",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :students_dg}],
          :order => 5
        },
        :commit_filled_hs => {
          :label => "6. Number of commitments to be filled with Holy Spirit or Lordship commitments",
          :collected => :weekly,
          :column_type => :sum,
          :columns_sum => [{:report => :weekly_p2c_special, :line => :commit_filled_hs}],
          :order => 6
        },
        :sharing_in => {
          :label => "7. Number of people who are sharing their faith a. with P2C",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :sharing_in}],
          :order => 7
        },
        :sharing_out => {
          :label => "b. outside P2C",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :sharing_out}],
          :order => 8
        },
        :trained_to_share_in => {
          :label => "8. Number of People *trained* to share their faith in the power of the Holy Spirit a. with P2C",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :trained_to_share_in}],
          :order => 9
        },
        :trained_to_share_out => {
          :label => "b. outside P2C",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :trained_to_share_out}],
          :order => 10
        },
        :spirit_mult => {
          :label => "9. Number of people actually leading others to do faith adventures (spiritual multipliers)",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :spirit_mult}],
          :order => 11
        }
      },
      :annual_goals_report => {
          :students_in_ministry => {:column => :annualGoalsReport_studInMin, 
           :label => "Total students involved in campus ministry",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 1}, 
          :spiritual_multipliers => {:column => :annualGoalsReport_sptMulti, 
           :label => "Total spiritual multipliers",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 2}, 
          :first_years => {:column => :annualGoalsReport_firstYears, 
           :label => "Total first-year students involved",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 3}, 
          :total_went_to_summit => {:column => :annualGoalsReport_summitWent, 
           :label => "Total students that went to Summit",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 4}, 
          :total_went_to_wc => {:column => :annualGoalsReport_wcWent, 
           :label => "Total students that went to Winter Conference",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 5},
          :total_went_on_project => {:column => :annualGoalsReport_projWent, 
           :label => "Total students that went on a project",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 6}, 
          :spiritual_conversations => {:column => :annualGoalsReport_spConvTotal, 
           :label => "Total spiritual conversations",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 7}, 
          :gospel_presentations => {:column => :annualGoalsReport_gosPresTotal, 
           :label => "Total Gospel presentations",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 8}, 
          :holyspirit_presentations => {:column => :annualGoalsReport_hsPresTotal, 
           :label => "Total people doing one-year internships",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 9}, 
          :indicated_decisions => {:column => :annualGoalsReport_prcTotal, 
           :label => "Total indicated decisions to follow Jesus",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 10},
          :followup_completed => {:column => :annualGoalsReport_integBelievers, 
           :label => "Total integrated new believers",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 11}, 
          :large_event_attendance => {:column => :annualGoalsReport_lrgEventAttend, 
           :label => "Total attendance at large events",
            :collected => :yearly,
            :column_type => :database_column,
            :order => 12               
            }
      }

    }
  end

  
  def eventbrite
    {
      :campus_question => "Your Campus",
      :year_question => "Your Year",
      :event_status_live => "Live",
      :male => "Male",
      :female => "Female"
    }
  end
