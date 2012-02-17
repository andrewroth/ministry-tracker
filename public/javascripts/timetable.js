function findPos(obj) {
  var curleft = curtop = 0;
  if (obj.offsetParent) {
    do {
      curleft += obj.offsetLeft;
      curtop += obj.offsetTop;
    } while (obj = obj.offsetParent);
  }
  return [ curleft, curtop ];
}

schedLeft = schedTop = 0;

$(document).ready(function() {
  initializeSchedHead();
  setTimeout("initializeSchedHead();", 1000); // give time for connexionbar
});

function initializeSchedHead() {
  $('#schedule_header').width($('#schedule').width() + "px");
  [ schedLeft, schedTop ] = findPos($('#schedule')[0]);
  $('#schedule_header').css('left', schedLeft);
  updateHeaderVisibility();
}

function scrollTop() {
  return filterResults (
    window.pageYOffset ? window.pageYOffset : 0,
    document.documentElement ? document.documentElement.scrollTop : 0,
    document.body ? document.body.scrollTop : 0
  );
}

function filterResults(n_win, n_docel, n_body) {
  var n_result = n_win ? n_win : 0;
  if (n_docel && (!n_result || (n_result > n_docel)))
    n_result = n_docel;
  return n_body && (!n_result || (n_result > n_body)) ? n_body : n_result;
}

function updateHeaderVisibility() {
  if (schedTop == 0) {
    return;
  }
  if (scrollTop() > schedTop) {
    $("#schedule_header").show();
  } else {
    $("#schedule_header").hide();
  }
}

$(window).scroll(updateHeaderVisibility);



/***********************************************/
// functions for horizontal time table compare //
/***********************************************/

function zoom_adjustments(width) {
  if (width >= 10000) {
    $(".horizTableCompare .zoom1").show();
    $(".horizTableCompare .zoom2").show();
    $(".horizTableCompare .zoom3").show();
    $(".horizTableCompare .zoom4").show();
  }
  else if (width >= 4000) {
    $(".horizTableCompare .zoom1").show();
    $(".horizTableCompare .zoom2").show();
    $(".horizTableCompare .zoom3").show();
    $(".horizTableCompare .zoom4").hide();
  }
  else if (width >= 1700) {
    $(".horizTableCompare .zoom1").show();
    $(".horizTableCompare .zoom2").show();
    $(".horizTableCompare .zoom3").hide();
    $(".horizTableCompare .zoom4").hide();
  }
  else if (width >= 900) {
    $(".horizTableCompare .zoom1").show();
    $(".horizTableCompare .zoom2").hide();
    $(".horizTableCompare .zoom3").hide();
    $(".horizTableCompare .zoom4").hide();
  }
  else if (width >= 0) {
    $(".horizTableCompare .zoom1").hide();
    $(".horizTableCompare .zoom2").hide();
    $(".horizTableCompare .zoom3").hide();
    $(".horizTableCompare .zoom4").hide();
  }

}
