class FillPreviousLnzValuesForP2cReports < ActiveRecord::Migration
  SEMESTER_LNZ_COLUMNS = {:semesterreport_lnz_p2c_numInEvangStudies => :montlyreport_p2c_numInEvangStudies, 
                          :semesterreport_lnz_p2c_numSharingInP2c => :montlyreport_p2c_numSharingInP2c, 
                          :semesterreport_lnz_p2c_numSharingOutP2c => :montlyreport_p2c_numSharingOutP2c}
  
  ANNUAL_LNZ_COLUMNS = {:semesterreport_lnz_p2c_numInEvangStudies => :montlyreport_p2c_numInEvangStudies, 
                        :semesterreport_lnz_p2c_numSharingInP2c => :montlyreport_p2c_numSharingInP2c, 
                        :semesterreport_lnz_p2c_numSharingOutP2c => :montlyreport_p2c_numSharingOutP2c}
  
  def self.create_semester_report(campus_id, semester_id)
    sr = SemesterReport.new()
    sr[:campus_id] = campus_id
    sr[:semester_id] = semester_id
    sr
  end
  
  def self.get_semester_report(campus_id, semester_id)
    sr = SemesterReport.find(:first, :conditions => { :campus_id => campus_id, :semester_id => semester_id})
    sr ||= create_semester_report(campus_id, semester_id)
    sr
  end
  
  def self.create_annual_report(campus_id, year_id)
    ar = AnnualReport.new()
    ar[:campus_id] = campus_id
    ar[:year_id] = year_id
    ar
  end
  
  def self.get_annual_report(campus_id, year_id)
    ar = AnnualReport.find(:first, :conditions => { :campus_id => campus_id, :year_id => year_id})
    ar ||= create_annual_report(campus_id, year_id)
    ar
  end
  
  def self.up
    campuses = Campus.all.collect {|c| c[:campus_id]}
    semesters = Semester.all.collect {|s| s[:semester_startDate] < Time.now.to_date ? s : nil}.compact
    years = Year.all.collect {|y| y.start_date < Time.now.to_date ? y : nil}.compact

    semesters.each do |semester|
      campuses.each do |c|
        monthly_reports = []
        semester.months.each do |month|
          monthly_reports.concat(month.monthly_reports.find(:all, :conditions => {:campus_id => c}))
        end
        unless monthly_reports.empty?
          sr = get_semester_report(c, semester[:semester_id])
          have_to_update_values = false
          SEMESTER_LNZ_COLUMNS.each do |k, v|
            sr[k] = 0
            monthly_reports.each do |mr|
              if mr[v] != 0
                have_to_update_values = true
                sr[k] = mr[v]
              end
            end
          end
          sr.save! if have_to_update_values
        end
      end
    end

    years.each do |year|
      campuses.each do |c|
        monthly_reports = []
        year.months.each do |month|
          monthly_reports.concat(month.monthly_reports.find(:all, :conditions => {:campus_id => c}))
        end
        unless monthly_reports.empty?
          ar = get_annual_report(c, year[:year_id])
          have_to_update_values = false
          ANNUAL_LNZ_COLUMNS.each do |k, v|
            ar[k] = 0
            monthly_reports.each do |mr|
              if mr[v] != 0
                have_to_update_values = true
                ar[k] = mr[v]
              end
            end
          end
          ar.save! if have_to_update_values
        end
      end
    end

  
  end

  def self.down
  end
end
