/**
 * @author jacques
 */

function selectMonthlyInputFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingMonthlyInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/monthly_reports/select_report'})
}


function getRecordInfos()
{
  month_id = jQuery("#monthly_report_month_id")[0].value;
  campus_id = jQuery("#monthly_report_campus_id")[0].value;
  return "month_id=" + month_id + "&campus_id=" + campus_id;
}
 
 function beginLoadingInputTab() {
  jQuery('.reportInputContainer').hide();
  jQuery('.reportInputContainer').visualEffect('fade');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
  selectMonthlyInputFields();
}

function completeLoadingMonthlyInputTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportInputContainer').show();
  jQuery('.reportInputContainer').visualEffect('appear');
}

