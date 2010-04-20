
// generate the string for observe_field's :with
function getWithStringForReportForm(ministry, summary, time) {

  if(summary == undefined || summary == null) {
    summary = document.getElementById('report_summary_summary').checked;
  }

  if(time == undefined || time == null) {
    time = jQuery(".statsTabActive")[0].title;
  }

  if(ministry == undefined || ministry == null) {
    ministry_select = document.getElementById('report_ministry');
    ministry = ministry_select.options[ministry_select.selectedIndex].value;
  }

  return 'ministry=' + ministry + '&summary=' + summary + '&time=' + time
}


function beginLoadingStatsTab() {
  jQuery('.statsReportTabContainer').hide();
  jQuery('.statsTabContainerActive').visualEffect('blind_up');
  jQuery('#spinnerStatsResults').show();
}

function completeLoadingStatsTab() {
  jQuery('#spinnerStatsResults').hide();
}