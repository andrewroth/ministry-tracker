/**
 * @author hobbe (thanks to jacques for model code in semester_reports.js)
 */

function selectInputFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingPrcInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/prcs/select_prc_report'})
}

function refreshIndexFields() {
  jQuery.ajax({
    complete: function(request){ completeLoadingPrcIndexTab() },
    data: getIndexInfo(),
    dataType:'script',
    type:'post',
    url:'/prcs/refresh_prc_index'})
}


function getRecordInfos()
{
  semester_id = jQuery("#prc_semester_id")[0].value;
  campus_id = jQuery("#prc_campus_id")[0].value;
	date = jQuery("#prc_date")[0].value;
  return "semester_id=" + semester_id + "&campus_id=" + campus_id + "&date=" + date;
}

function getIndexInfo()
{
  semester_id = jQuery("#prc_semester_id")[0].value;
  campus_id = jQuery("#prc_campus_id")[0].value;
  return "semester_id=" + semester_id + "&campus_id=" + campus_id;
}
 
 function beginLoadingPrcInputTab() {
  jQuery('.reportInputContainer').hide();
  jQuery('.reportInputContainer').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
  selectInputFields();
}

function completeLoadingPrcInputTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportInputContainer').show();
  jQuery('.reportInputContainer').visualEffect('appear');
}

function beginLoadingPrcIndexTab() {
  jQuery('.reportIndexContainer').hide();
  jQuery('.reportIndexContainer').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
  refreshIndexFields();
}

function completeLoadingPrcIndexTab() {
  jQuery('#statsSpinnerContainer').hide();
  jQuery('.reportIndexContainer').show();
  jQuery('.reportIndexContainer').visualEffect('appear');
}

