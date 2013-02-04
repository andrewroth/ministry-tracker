$(function() {
  selectReport();
});


function selectReport(extra_data) {
  if(extra_data !== undefined) {
    extra_data = '&' + extra_data;
  }
  else {
    extra_data = '';
  }

  beginLoadingStatsTab();
  $.ajax({
    complete: function(request){ completeLoadingStatsTab(); },
    data: getWithStringForReportForm()+extra_data,
    dataType:'script',
    type:'post',
    url:'/stats/select_report'});
}

// generate the string for observe_field's :with
function getWithStringForReportForm(time, ministry, scope, report_type) {

  if(scope === undefined || scope === null) {
		scope = 'summary';
    var radios = $(":input[name=report\\[scope\\]]");
    for(var i = 0; i < radios.length; i++) {
      if(radios[i].checked) { scope = radios[i].value; }
    }
  }

  if(time === undefined || time === null) {
    time = $(".statsTabActive")[0].id;
  }

  if(ministry === undefined || ministry === null) {
    ministry = $("#report_ministry")[0].value;
    // ministry_select = document.getElementById('report_ministry');
    // ministry = ministry_select.options[ministry_select.selectedIndex].value;
  }

  if(report_type === undefined || report_type === null) {
    report_type = $("#report_report_type")[0].value;
  }

  return 'ministry=' + ministry + '&report_scope=' + scope + '&time=' + time + '&report_type=' + report_type;
}

function reportTypeChange(newTitle){
	beginLoadingStatsTab();
  document.title = document.title.replace(/[^|]*[|]/, newTitle + ' |');
	//$("#reportTypeTitle").html = newTitle;
}

function beginLoadingStatsTab() {
  $('.statsReportTabContainer, .statsTabContainerActive').fadeOut('fast', function() {
    $('#statsSpinnerContainer').fadeIn('fast');
  });
}

function completeLoadingStatsTab() {
  $('#statsSpinnerContainer').hide();

  $('table.dataTable').dataTable({
    "iDisplayLength" : 100,
    "bDestroy": true,
    "bJQueryUI": true,
    "sPaginationType": "full_numbers"
  });

  $('a.select_report_sort').on('click', function(e) {
    e.preventDefault();
    selectReport('sort=' + $(this).data('sort-col') + '&' + 'direction=' + $(this).data('sort-dir'));
  });
}