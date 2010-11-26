class MonthlyReportsController < ReportsController
  unloadable

  def identification_fields
    [:month_id, :campus_id]
  end

  def report_model
    MonthlyReport
  end

  def input_reports
    [:monthly_report, :monthly_p2c_special]
  end

  def after_saving
    monthly_reports_this_year = get_monthly_reports_for_period(get_year)
    monthly_reports_this_semester = get_monthly_reports_for_period(get_semester)
    
    sr = get_semester_report
    ar = get_annual_report
    
    lnz_input_lines.each do |lil|
      sr[lil[1][:lnz_correspondance][:semester_report]] = last_non_zero(monthly_reports_this_semester, lil[1][:column])
      ar[lil[1][:lnz_correspondance][:annual_report]] = last_non_zero(monthly_reports_this_year, lil[1][:column])
    end
    sr.save!
    ar.save!
  end

  def last_non_zero(reports, column)
    lnz = 0
    reports.each do |r|
      lnz = r[column] unless r[column] == 0
    end
    lnz
  end

  def lnz_input_lines
    @lnz_input_lines ||= input_lines.collect {|il| il[1][:grouping_method] == :last_non_zero ? il : nil}.compact 
  end

  def get_monthly_reports_for_period(period)
    period.months.collect {|month| month.monthly_reports.find(:all, :conditions => {:campus_id => @report[:campus_id]})}.flatten
  end

  def get_semester_report
    sr = SemesterReport.find(:first, :conditions => { :campus_id => @report[:campus_id], :semester_id => get_semester_id})
    sr ||= create_semester_report(@report[:campus_id], get_semester_id)
    sr
  end
  
  def get_annual_report
    ar = AnnualReport.find(:first, :conditions => { :campus_id => @report[:campus_id], :year_id => get_year_id})
    ar ||= create_annual_report(@report[:campus_id], get_year_id)
    ar
  end

  def get_semester
    @get_semester ||= @report.month.semester
  end

  def get_semester_id
    @get_semester_id ||= get_semester.id
  end

  def get_year
    @get_year ||= @report.month.year
  end

  def get_year_id
    @get_year_id ||= get_year.id
  end

  def create_semester_report
    sr = SemesterReport.new()
    sr[:campus_id] = @report[:campus_id]
    sr[:semester_id] = get_semester_id
    sr
  end
  
  def create_annual_report
    ar = AnnualReport.new()
    ar[:campus_id] = @report[:campus_id]
    ar[:year_id] = get_year_id
    ar
  end
  

end

