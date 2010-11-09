class WeeklyReportsController < ReportsController
  unloadable

  def identification_fields
    [:staff_id, :week_id, :campus_id]
  end

  def report_model
    WeeklyReport
  end

  def url_to_redirect_after_update
    url_for(:controller => :prcs, :action => :index)
  end

  def input_reports
    [:weekly_report, :weekly_p2c_special]
  end

end
