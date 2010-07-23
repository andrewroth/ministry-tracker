/**
 * @author jacques
 */
function selectWeeklyInputFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingWeeklyInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/weekly_reports/select_weekly_report'})
}


function getRecordInfos()
{
  week_id = jQuery("#weekly_report_week_id")[0].value;
  campus_id = jQuery("#weekly_report_campus_id")[0].value;
  return "week_id=" + week_id + "&campus_id=" + campus_id;
}
 
 function beginLoadingWeeklyInputTab() {
  jQuery('.reportInputContainer').hide();
  jQuery('.reportInputContainer').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
  selectWeeklyInputFields();
}

function completeLoadingWeeklyInputTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportInputContainer').show();
  jQuery('.reportInputContainer').visualEffect('appear');
}

