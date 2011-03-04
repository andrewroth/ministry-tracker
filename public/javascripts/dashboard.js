$(document).ready(function(){

  // set vertical bracket height
  $("#verticalTablistContainer").height($(".colmask").height());

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

  // eventbrite
  requestMyEvents();
});

function requestMyEvents() {
  jQuery.ajax({
    dataType:'script',
    type:'post',
    url:'/dashboard/events'})
}