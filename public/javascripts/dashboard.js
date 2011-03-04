$(document).ready(function(){
  $("#verticalTablistContainer").height($(".colmask").height());

  requestMyEvents();
});

function requestMyEvents() {
  jQuery.ajax({
    dataType:'script',
    type:'post',
    url:'/dashboard/events'})
}