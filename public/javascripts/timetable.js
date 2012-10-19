

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
