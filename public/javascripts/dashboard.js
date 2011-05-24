$(document).ready(function(){

  // set vertical bracket height
  adjustBracketHeight();

  // change img source on mouseover
  $(function() {
    $("img.mouseover")
      .mouseover(function() {
        var src = $(this).attr("src").match(/[^\.]+/) + "Y.png";
        $(this).attr("src", src);
      })
      .mouseout(function() {
        var src = $(this).attr("src").replace("Y", "");
        $(this).attr("src", src);
      });
  });

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
