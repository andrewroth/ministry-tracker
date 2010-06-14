module SemesterReportsHelper
  unloadable

  def show_input_lines(semester_report)
    render :partial => 'semester_reports/input_lines',
    :locals => {
        :semester_report => semester_report
    }
  end
 
end
