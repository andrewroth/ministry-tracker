$(document).ready(function(){selectReport()});


function selectReport() {
  beginLoadingStatsTab();
  jQuery.ajax({
    complete: function(request){ completeLoadingStatsTab() },
    data: getWithStringForReportForm(),
    dataType:'script',
    type:'post',
    url:'/stats/select_report'})
}

// generate the string for observe_field's :with
function getWithStringForReportForm(time, ministry, summary) {

  if(summary == undefined || summary == null) {
    summary = document.getElementById('report_summary_summary').checked;
  }

  if(time == undefined || time == null) {
    time = jQuery(".statsTabActive")[0].id;
  }

  if(ministry == undefined || ministry == null) {
    ministry = jQuery("#report_ministry")[0].value;
//    ministry_select = document.getElementById('report_ministry');
//    ministry = ministry_select.options[ministry_select.selectedIndex].value;
  }

  return 'ministry=' + ministry + '&summary=' + summary + '&time=' + time
}


function beginLoadingStatsTab() {
  jQuery('.statsReportTabContainer').hide();
  jQuery('.statsTabContainerActive').visualEffect('drop_out');
  jQuery('#statsSpinnerContainer').visualEffect('appear');
}

function completeLoadingStatsTab() {
  jQuery('#statsSpinnerContainer').hide();
}

