/**
 * @author hobbe (thanks to jacques for model code in semester_reports.js)
 */

function selectInputFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingAnnualGoalsInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/annual_goals_reports/select_annual_goals_report'})
}


function getRecordInfos()
{
  year_id = jQuery("#annual_goals_report_year_id")[0].value;
  campus_id = jQuery("#annual_goals_report_campus_id")[0].value;
  return "year_id=" + year_id + "&campus_id=" + campus_id;
}
 
 function beginLoadingAnnualGoalsInputTab() {
  jQuery('.reportInputContainer').hide();
  jQuery('.reportInputContainer').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
  selectInputFields();
}

function completeLoadingAnnualGoalsInputTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportInputContainer').show();
  jQuery('.reportInputContainer').visualEffect('appear');
}

