// tooltip widget
function toggleTooltip(event, element) { 
  var __x = event.pageX;
  var __y = event.pageY;
  //alert(__x+","+__y);
  element.css('top', __y + 5);  
  element.css('left', __x - 40);
  element.toggle();
}