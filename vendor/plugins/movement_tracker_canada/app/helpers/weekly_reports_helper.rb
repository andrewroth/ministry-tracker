module WeeklyReportsHelper
  unloadable

  def show_input_lines(weekly_report)
    render :partial => 'weekly_reports/input_lines',
    :locals => {
        :weekly_report => weekly_report
    }
  end
 
end
