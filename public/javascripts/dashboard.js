$(document).ready(function(){

  // set vertical bracket height
  adjustBracketHeight();

  // add student tab is a remote link
  $("#addStudentTab").click(function(e) {
    e.preventDefault();
    $.ajax({beforeSend:function(request){$('#spinneradd_student').show();}, complete:function(request){$('#spinneradd_student').hide(); show_add_student()}, dataType:'script', type:'get', url:'/people/add_student'});
  });

  // eventbrite
  requestMyEvents();
});

function requestMyEvents() {
  jQuery.ajax({
    dataType:'script',
    type:'post',
    url:'/dashboard/events'})
}

function adjustBracketHeight() {
  $("#verticalTablistContainer").height($("#dashwrap .col1").height());
}
