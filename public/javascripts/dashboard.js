$(document).ready(function(){requestMyEvents()});

function requestMyEvents() {
  jQuery.ajax({
    dataType:'script',
    type:'post',
    url:'/dashboard/events'})
}