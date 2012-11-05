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
      :c4c => {:order => 1, :label => "P2C-S Reports", :controller => :stats, :action => :index, :scopes => [:summary, :campus_drill_down, :staff_drill_down]},
      :p2c => {:order => 5, :label => "Power to Change Reports", :controller => :stats, :action => :show_p2c_report, :scopes => [:summary]},
      :ccci => {:order => 6, :label => "CCCI Reports", :controller => :stats, :action => :show_ccci_report, :scopes => [:summary, :campus_drill_down]},
      :hpctc => {:order => 2, :label => "How People Came to Christ", :controller => :stats, :action => :how_people_came_to_christ, :scopes => [:summary]},
      :story => {:order => 3, :label => "Salvation Story Synopses", :controller => :stats, :action => :salvation_story_synopses, :scopes => [:summary]},
      :labelled_people => {:order => 8, :label => "Label Report", :controller => :stats, :action => :labelled_people, :scopes => [:summary]},

      :annual_goals => {:hidden => true, :order => 3, :label => "Goals Progress Report", :controller => :stats, :action => :annual_goals, :scopes => [:summary]},
      :comp => {:hidden => true, :order => 4, :label => "Compliance Reports", :controller => :stats, :action => :show_compliance_report, :scopes => [:staff_drill_down]},
      :perso => {:hidden => true, :order => 7, :label => "My Personal Stats", :controller => :stats, :action => :personal, :scopes => [:summary, :campus_drill_down]},
      :one_stat => {:hidden => true, :order => 0, :label => "Single Stat Report", :controller => :stats, :action => :one_stat, :scopes => [:one_stat]}
    }
  end

  def report_scopes
    {
      :summary => {
                    :order => 1,
                    :label => "Summary",
                    :title => "See a summary of all the campuses under the selected ministry",
                    :radio_id => "report_scope_summary",
                    :show => :yes
      },
      :campus_drill_down => {
                    :order => 2,
                    :label => "Campus drill-down",
                    :title => "See individual campuses under the selected ministry",
                    :radio_id => "report_scope_campus_drill_down",
                    :show => :yes
      },
      :staff_drill_down => {
                    :order => 3,
                    :label => "Staff drill-down",
                    :title => "See individual staff members under the selected ministry",
                    :radio_id => "report_scope_staff_drill_down",
                    :show => :no
      },
      :one_stat => {
                    :order => 4,
                    :label => "Single Stat",
                    :title => "See campus drill-down over time for a single stat under the selected ministry",
                    :radio_id => "report_scope_one_stat",
                    :show => :no
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
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 1,
            :display => :false},
          :tot_grad_c4c_staff => {:column => :semesterreport_totalFullTimeC4cStaff,
           :label => "Total full time C4C staff",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 2,
            :display => :false},
          :tot_grad_p2c_staff => {:column => :semesterreport_totalFullTimeP2cStaffNonC4c,
           :label => "Total full time P2C staff (non-campus)",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 3,
            :display => :false},
          :tot_grad_intern => {:column => :semesterreport_totalPeopleOneYearInternship,
           :label => "Total people doing one-year internships",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 4,
            :display => :false},
          :tot_grad_other_ministry => {:column => :semesterreport_totalPeopleOtherMinistry,
           :label => "Total people doing other full time ministry",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 5,
            :display => :false},
          :students_attending_summit => {:column => :semesterreport_studentsSummit,
           :label => "Students attending Summit",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 6,
            :display => :false},
          :students_going_to_wc => {:column => :semesterreport_studentsWC,
           :label => "Students going to Winter Conference",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 7,
            :display => :false},
          :students_going_to_projects => {:column => :semesterreport_studentsProjects,
           :label => "Students going to projects",
            :collected => :semesterly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 8,
            :display => :false}
      },
        :weekly_report => {
           :spirit_conversations => {:column => :weeklyReport_1on1SpConv,
             :label => "Spiritual Conversations",
             :collected => :weekly,
             :column_type => :database_column,
             :grouping_method => :sum,
             :display_type => :text_positive_integer,
             :order => 1,
             :display => :false
           },
           :spirit_conversations_disciples => {
             :column => :weeklyReport_1on1SpConvStd,
             :label => "Spiritual Conversations by Disciples",
             :collected => :weekly,
             :column_type => :database_column,
             :grouping_method => :sum,
             :display_type => :text_positive_integer,
             :order => 2,
             :display => :false
           },
           :spirit_conversations_total => {
             :label => "Spiritual Conversations Total",
             :collected => :weekly,
             :css_class => " statsTableTotal",
             :column_type => :sum,
             :columns_sum => [{:report => :weekly_report, :line => :spirit_conversations},
                              {:report => :weekly_report, :line => :spirit_conversations_disciples}],
             :order => 3,
             :display => :false
           },
           :gospel_pres => {
             :column => :weeklyReport_1on1GosPres,
             :label => "Gospel Presentations",
             :collected => :weekly,
             :column_type => :database_column ,
             :grouping_method => :sum,
             :display_type => :text_positive_integer,
             :order => 4,
             :display => :false
           },
           :gospel_pres_disciples => {
             :column => :weeklyReport_1on1GosPresStd,
             :label => "Gospel Presentations by Disciples",
             :collected => :weekly,
             :column_type => :database_column,
             :grouping_method => :sum,
             :display_type => :text_positive_integer,
             :order => 5,
             :display => :false
           },
           :gospel_pres_total => {
             :label => "Gospel Presentations Total",
             :collected => :weekly,
             :css_class => " statsTableTotal",
             :column_type => :sum,
             :columns_sum => [{:report => :weekly_report, :line => :gospel_pres},
                              {:report => :weekly_report, :line => :gospel_pres_disciples}],
             :order => 6,
             :display => :false
           },
           :holy_spirit_pres => {
             :column => :weeklyReport_1on1HsPres,
             :label => "Holy Spirit Presentations",
             :collected => :weekly,
             :column_type => :database_column ,
             :grouping_method => :sum,
             :display_type => :text_positive_integer,
             :order => 7,
             :display => :false
           }
      },
      :indicated_decisions_report => {
#           :blank_line => {
#             :column_type => :blank_line ,
#             :order => 0
#           },
           :indicated_decisions => {
             :label => "Indicated Decisions",
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :sum,
             :order => 5
           }
        },
        :indicated_decision_report => {
            :campus_id => {
             :column => :campus_id,
             :label => "Campus",
             :display_type => :drop_down,
             :required => true,
             :drop_down_data => :campus,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 0
           },
           :semester_id => {
             :column => :semester_id,
             :label => "Semester",
             :display_type => :drop_down,
             :required => true,
             :drop_down_data => :semester,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 1
           },
           :decision_date => {
             :column => :prc_date,
             :label => "Date",
             :display_type => :date_picker,
             :required => true,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 2
           },
           :believer_first_name => {
             :column => :prc_firstName,
             :label => "New believer's first name",
             :required => true,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 3
           },
           :witness_name => {
             :column => :prc_witnessName,
             :label => "Witness name",
             :required => true,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 4
           },
           :method => {
             :column => :prcMethod_id,
             :label => "Method",
             :display_type => :drop_down,
             :required => true,
             :drop_down_data => :prc_method,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 5
           },
           :integrated_believer => {
             :column => :prc_7upCompleted,
             :label => "Integrated believer?",
             :display_type => :checkbox,
             :required => false,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 6
           },
           :notes => {
             :column => :prc_notes,
             :label => "Story",
             :display_type => :text_area,
             :required => true,
             :collected => :prc,
             :column_type => :database_column ,
             :grouping_method => :none,
             :order => 7
           }
      },
        :monthly_report_input => {
          :event_exposures => {:column => :monthlyreport_event_exposures,
            :label => "Non-Christians attending outreach events",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 3
          },
          :unrecorded_engagements => {:column => :monthlyreport_unrecorded_engagements,
            :label => "Unrecorded Engagements",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 4
          },
          :students_dg => {:column => :monthlyreport_totalStudentInDG,
            :label => "Growing Disciples (defaults to # in DG)",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_totalStudentInDG,
                                    :annual_report => :annualReport_lnz_totalStudentInDG},
            :display_type => :text_positive_integer,
            :order => 5
          },
          :ministering_disciples => {:column => :monthlyreport_ministering_disciples,
            :label => "Ministering Disciples (defaults to # student/ministry leaders)",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_ministering_disciples,
                                    :annual_report => :annualReport_lnz_ministering_disciples},
            :display_type => :text_positive_integer,
            :order => 6
          },
          :spirit_mult => {:column => :monthlyreport_totalSpMult,
            :label => "Multiplying Disciples",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_totalSpMult,
                                    :annual_report => :annualReport_lnz_totalSpMult},
            :display_type => :text_positive_integer,
            :order => 7
          }
      },
        :monthly_report => {
          :event_exposures => {:column => :monthlyreport_event_exposures,
            :label => "Non-Christians attending outreach events",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 1
          },
          :survey_contacts_engagements => {
            :label => "September 2012 Launch Face-to-Face Engagements",
            :collected => :weekly,
            :column_type => :count_model_with_condition,
            :grouping_method => :none,
            :model => 'SurveyContact',
            :conditions => { :result => [5, 6, 7] },
            :order => 2
          },
          :discover_contacts_engagements => {
            :label => "Discover Contact Engagements",
            :collected => :weekly,
            :column_type => :count_model_with_condition,
            :grouping_method => :none,
            :model => 'DiscoverContact',
            :order => 3
          },
          :unrecorded_engagements => {:column => :monthlyreport_unrecorded_engagements,
            :label => "Unrecorded Engagements",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 4
          },
          :students_dg => {:column => :monthlyreport_totalStudentInDG,
            :label => "Growing Disciples",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_totalStudentInDG,
                                    :annual_report => :annualReport_lnz_totalStudentInDG},
            :display_type => :text_positive_integer,
            :order => 6
          },
          :ministering_disciples => {:column => :monthlyreport_ministering_disciples,
            :label => "Ministering Disciples",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_ministering_disciples,
                                    :annual_report => :annualReport_lnz_ministering_disciples},
            :display_type => :text_positive_integer,
            :order => 7
          },
          :spirit_mult => {:column => :monthlyreport_totalSpMult,
            :label => "Multiplying Disciples",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_totalSpMult,
                                    :annual_report => :annualReport_lnz_totalSpMult},
            :display_type => :text_positive_integer,
            :order => 8
          },
          :avg_hours_prayer => {:column => :monthlyreport_avgPrayer,
            :label => "Average - weekly hours of prayer",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_avgPrayer,
                                    :annual_report => :annualReport_lnz_avgPrayer},
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :frosh => {:column => :monthlyreport_numFrosh,
            :label => "Number of frosh involved",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_numFrosh,
                                    :annual_report => :annualReport_lnz_numFrosh},
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :evt_spirit_conv => {:column => :monthlyreport_eventSpirConversations,
            :label => "Event exposures - Spiritual Conversations",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :evt_gos_pres => {:column => :monthlyreport_eventGospPres,
            :label => "Event exposures - Gospel Presentations",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :med_spirit_conv => {:column => :monthlyreport_mediaSpirConversations,
            :label => "Media exposures - Spiritual Conversations",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :med_gos_pres => {:column => :monthlyreport_mediaGospPres,
            :label => "Media exposures - Gospel Presentations",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :core_students => {:column => :monthlyreport_totalCoreStudents,
            :label => "Total core students",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_totalCoreStudents,
                                    :annual_report => :annualReport_lnz_totalCoreStudents},
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :integrated_new_believers => {:column => :montlyreport_integratedNewBelievers,
            :label => "Integrated new believers",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 0,
            :display => :false
          },
          :growth_rate => {
            :label => "Conversion growth rate",
            :collected => :monthly,
            :column_type => :division,
            :dividend => {:report => :monthly_report, :line => :integrated_new_believers},
            :divisor => {:report => :monthly_report, :line => :students_dg},
            :order => 0,
            :display => :false
          }
      },
      :weekly_p2c_special => {
          :commit_filled_hs => {:column => :weeklyReport_p2c_numCommitFilledHS,
            :label => "Number of commitments to be filled with Holy Spirit or Lordship commitments",
            :collected => :weekly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 1
          }
      },
        :monthly_p2c_special => {
          :evang_studies => {:column => :montlyreport_p2c_numInEvangStudies,
            :submit_label => "Number of people in evangelistic studies (i.e. discovery groups or individual sessions)",
            :label => "Number of people in evangelistic studies",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_p2c_numInEvangStudies,
                                    :annual_report => :annualreport_lnz_p2c_numInEvangStudies},
            :display_type => :text_positive_integer,
            :order => 1
          },
          :trained_to_share_in => {:column => :montlyreport_p2c_numTrainedToShareInP2c,
            :label => "Number of People *trained* to share their faith in the power of the Holy Spirit a. with P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 2
          },
          :trained_to_share_out => {:column => :montlyreport_p2c_numTrainedToShareOutP2c,
            :label => "b. outside P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 3
          },
          :sharing_in => {:column => :montlyreport_p2c_numSharingInP2c,
            :label => "Number of people who are sharing their faith a. with P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_p2c_numSharingInP2c,
                                    :annual_report => :annualreport_lnz_p2c_numSharingInP2c},
            :display_type => :text_positive_integer,
            :order => 4
          },
          :sharing_out => {:column => :montlyreport_p2c_numSharingOutP2c,
            :label => "b. outside P2C",
            :collected => :monthly,
            :column_type => :database_column,
            :grouping_method => :last_non_zero,
            :lnz_correspondance => {:semester_report => :semesterreport_lnz_p2c_numSharingOutP2c,
                                    :annual_report => :annualreport_lnz_p2c_numSharingOutP2c},
            :display_type => :text_positive_integer,
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
          :show_total => false,
          :order => 3
        },
        :build_group_members => {
          :label => "4. BUILD - MOVEMENT (ACTION) GROUP MEMBERS",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :core_students}],
          :show_total => false,
          :order => 4
        },
        :send_group_leaders => {
          :label => "5. SEND - MOVEMENT (ACTION) GROUP LEADERS",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_report, :line => :spirit_mult}],
          :show_total => false,
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
          :show_total => false,
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
          :show_total => false,
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
          :show_total => false,
          :order => 7
        },
        :sharing_out => {
          :label => "b. outside P2C",
          :collected => :monthly,
          :column_type => :sum,
          :columns_sum => [{:report => :monthly_p2c_special, :line => :sharing_out}],
          :show_total => false,
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
          :show_total => false,
          :order => 11
        }
      },
      :annual_goals_report => {
          :students_in_ministry => {:column => :annualGoalsReport_studInMin,
           :label => "Total students involved in DGs",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 1},
          :spiritual_multipliers => {:column => :annualGoalsReport_sptMulti,
           :label => "Total spiritual multipliers",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 2},
          :first_years => {:column => :annualGoalsReport_firstYears,
           :label => "Total first-year students involved",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 3},
          :total_went_to_summit => {:column => :annualGoalsReport_summitWent,
           :label => "Total students that went to Summit",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 4},
          :total_went_to_wc => {:column => :annualGoalsReport_wcWent,
           :label => "Total students that went to Winter Conference",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 5},
          :total_went_on_project => {:column => :annualGoalsReport_projWent,
           :label => "Total students that went on a project",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 6},
          :spiritual_conversations => {:column => :annualGoalsReport_spConvTotal,
           :label => "Total spiritual conversations",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 7},
          :gospel_presentations => {:column => :annualGoalsReport_gosPresTotal,
           :label => "Total Gospel presentations",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 8},
          :holyspirit_presentations => {:column => :annualGoalsReport_hsPresTotal,
           :label => "Total Holy Spirit presentations",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 9},
          :indicated_decisions => {:column => :annualGoalsReport_prcTotal,
           :label => "Total indicated decisions to follow Jesus",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 10},
          :followup_completed => {:column => :annualGoalsReport_integBelievers,
           :label => "Total integrated new believers",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 11},
          :large_event_attendance => {:column => :annualGoalsReport_lrgEventAttend,
           :label => "Total attendance at large events",
            :collected => :yearly,
            :column_type => :database_column,
            :grouping_method => :sum,
            :display_type => :text_positive_integer,
            :order => 12
            }
      }

    }
  end

  def activity_options
    [["Interaction", 1], ["Spiritual Conversation", 2], ["Gospel Presentation", 3], ["Indicated Decision", 4], ["Shared Spirit-filled life", 5]]
  end


  def eventbrite
    # num_days_to_display_event_after_completed : stop advertising events on the dashboard after this many days have elapsed after the event is completed
    # num_days_until_event_closed_after_completed : Eventbrite closes events 5 days after they complete and pay out the money, say 6 just to be safe
    # num_days_sync_delay : only sync events if they haven't been synced for this many or more days
    {
      :campus_question => {:en => "Your Campus", :fr => "Votre campus"},
      :year_question => {:en => "Your Year", :fr => "Votre année scolaire"},
      :event_status_live => "Live",
      :event_status_completed => "Completed",
      :male => "Male",
      :female => "Female",
      :first_year => {:en => "1st Year (Undergrad)", :fr => "1ère année (1er cycle)"},
      :c4c_events_link => "http://p2c.eventbrite.com/",
      :num_days_to_display_event_after_completed => 10,
      :num_days_until_event_closed_after_completed => 6,
      :num_days_sync_delay => 1
    }
  end


  def google_search_appliance_config
    {
      :url => "https://search.mygcx.org/search",
      :client => "global",
      :ud => "0",
      :output => "xml_no_dtd",
      :site => "default_collection",
      :oe => "UTF-8",
      :ie => "UTF-8",
      :entqr => "3",
      :entsp => "a",
      :access => "a"
    }
  end


  def gcx_profile_report_config
    {
      :url => "https://www.mygcx.org/system/report/profile/attributes",
      :edit_url => "https://www.mygcx.org/Public/screen/profile?profile_combinerURL=globalProfile",
      :show_url => "https://www.mygcx.org/Public/screen/peopleLocator"
    }
  end

  TWITTER_URL = "https://twitter.com/#!/p2cstudents"
