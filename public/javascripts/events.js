$(document).ready(function(){selectReport()});


function selectReport() {
  beginLoading();
  jQuery.ajax({
    complete: function(request){ completeLoading() },
    data: getWithStringForReportForm(),
    dataType:'script',
    type:'post',
    url: ajax_base + 'select_report'})
}

// generate the string for observe_field's :with
function getWithStringForReportForm(scope, sort, campus) {

  if(scope == undefined || scope == null) {
    scope = 'summary';
    var radios = jQuery(":input[name=report\\[scope\\]]");
    for(var i = 0; i < radios.length; i++) {
      if(radios[i].checked) { scope = radios[i].value }
    }
  }

  if(sort == undefined || sort == null) { sort = 'last_name'; }

  if(campus == undefined || campus == null) { campus = '0'; }

  return '&attendance_report_scope=' + scope + '&attendance_report_sort=' + sort + '&attendance_campus_id=' + campus
}

function reportTypeChange(newTitle){
	beginLoadingStatsTab();
	// TODO: CHANGE THE PAGE'S TITLE
	//jQuery("#reportTypeTitle").html = newTitle;
}

function beginLoading() {
  jQuery('.statsReportTabContainer').hide();
  jQuery('.statsTabContainerActive').visualEffect('drop_out');
  jQuery('#attendanceSpinnerContainer').visualEffect('appear');
}

function completeLoading() {
  jQuery('#attendanceSpinnerContainer').hide();
}

