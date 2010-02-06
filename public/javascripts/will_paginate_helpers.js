 jQuery(document).ready(function() {
         
  jQuery('div.pagination a').livequery('click', function(e) {

    $.ajax({
      type: "GET",
      url: e.target.href,
      dataType: "script",
      beforeSend: function(){ $('div.pagination').replaceWith('<img src="images/spinner.gif">') }
    });
    return false;
  });
  
});

