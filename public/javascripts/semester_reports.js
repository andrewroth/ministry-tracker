/**
 * @author jacques
 */

function selectInputFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingSemesterInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/semester_reports/select_semester_report'})
}


function getRecordInfos()
{
	semester_id = jQuery("#semester_report_semester_id")[0].value;
  campus_id = jQuery("#semester_report_campus_id")[0].value;
	return "semester_id=" + semester_id + "&campus_id=" + campus_id;
}
 
 function beginLoadingSemesterInputTab() {
  jQuery('.reportInputContainer').hide();
  jQuery('.reportInputContainer').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
	selectInputFields();
}

function completeLoadingSemesterInputTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportInputContainer').show();
  jQuery('.reportInputContainer').visualEffect('appear');
}

