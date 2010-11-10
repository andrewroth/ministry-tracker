class SemesterReportsController < ReportsController
  unloadable

  def identification_fields
    [:semester_id, :campus_id]
  end

  def report_model
    SemesterReport
  end

  def input_reports
    [:semester_report]
  end


end

