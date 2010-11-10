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

end

