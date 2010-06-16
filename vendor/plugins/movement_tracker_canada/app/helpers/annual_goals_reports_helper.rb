module AnnualGoalsReportsHelper
  unloadable

  def show_input_lines(annual_goals_report)
    render :partial => 'annual_goals_reports/input_lines',
    :locals => {
        :annual_goals_report => annual_goals_report
    }
  end
 
end
