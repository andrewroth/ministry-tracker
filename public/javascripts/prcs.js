/**
 * @author hobbe (thanks to jacques for model code in semester_reports.js)
 */

function selectInputFields() {
  $.ajax({
    complete: function(request){ completeLoadingPrcInputTab() },
    data: getRecordInfos(),
    dataType:'script',
    type:'post',
    url:'/prcs/select_prc_report'})
}

function refreshIndexFields() {
  $.ajax({
    complete: function(request){ completeLoadingPrcIndexTab() },
    data: getIndexInfo(),
    dataType:'script',
    type:'post',
    url:'/prcs/refresh_prc_index'})
}


function getRecordInfos()
{
  semester_id = $("#prc_semester_id")[0].value;
  campus_id = $("#prc_campus_id")[0].value;
	date = $("#prc_date")[0].value;
  return "semester_id=" + semester_id + "&campus_id=" + campus_id + "&date=" + date;
}

function getIndexInfo()
{
  semester_id = $("#prc_semester_id")[0].value;
  campus_id = $("#prc_campus_id")[0].value;
  return "semester_id=" + semester_id + "&campus_id=" + campus_id;
}

 function beginLoadingPrcInputTab() {
  $('.reportInputContainer, #prcIndexFields').visualEffect('fade');
  $('#statsSpinnerContainer').visualEffect('appear');
  selectInputFields();
}

function completeLoadingPrcInputTab() {
  $('#statsSpinnerContainer').hide();
  $('.reportInputContainer, #prcIndexFields').visualEffect('appear');
}

function beginLoadingPrcIndexTab() {
  $('.reportIndexContainer, #prcIndexFields').visualEffect('fade');
  $('#statsSpinnerContainer').visualEffect('appear');
  refreshIndexFields();
}

function completeLoadingPrcIndexTab() {
  $('#statsSpinnerContainer').hide();
  $('.reportIndexContainer, #prcIndexFields').visualEffect('appear');
}

