$(document).ready(function(){requestMyEvents()});


function requestMyEvents() {
  beginLoading();
  jQuery.ajax({
    complete: function(request){ completeLoading() },
    dataType:'script',
    type:'post',
    url:'/dashboard/events'})
}

function beginLoading() {
}

function completeLoading() {
}

