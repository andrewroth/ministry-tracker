$(document).ready(function(){

  $('.pjax_container').pjax('a.pjax', {
    timeout: null,
    fragment: '.pjax_container'
  }).on('pjax:start', function(){
    $('.fade_on_pjax:visible').fadeTo('fast', 0.1);
  }).on('pjax:end', function(){
    $('.fade_on_pjax:visible').css('opacity', 1);
    ready();
  });

  ready();

});


function ready() {

  $('#contact_notes textarea').on('focus', function() {
    $(this).addClass('activated');
  });

  $('.discover_contacts_controls select#campus_id').on('change', function() {
    $.pjax({
      url: '/discover',
      data: { campus_id: $('.discover_contacts_controls select#campus_id').val() },
      container: '.pjax_container',
      fragment: '.pjax_container',
      timeout: null
    });
  });

}