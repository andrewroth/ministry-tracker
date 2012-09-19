$(document).ready(function(){
  $('input[name="contact[]"]').change( function(){
    var contact_array = Array();
    $('input[name="contact[]"]').each(function(index){
      if( $(this).is(':checked') ) contact_array.push($(this).val());
    });
    $('#contacts_to_update').val(contact_array.join());
  });
  
  $('#select_all_contacts').change( function(){
    $('input[name="contact[]"]').each(function(index){
      $(this).attr('checked', $('#select_all_contacts').is(':checked'));
      $(this).change();
    });
  });

  $('#campus_id').change( function() {
    adjustToCampus();
    $('a.report_link').attr('href', '/contacts/impact_report?campus_id=' + $('#campus_id').val() );
  });

  adjustToCampus();


  // show more search options
  $("#searchBox .show_more_conditions a").click(function(e) {
    e.preventDefault();
    $("#searchBox .show_more_conditions").hide();
    $("#searchBox.searchContacts .more_conditions").slideDown();
  });


  // multiple update
  $('#multiple_update_action').change(function(e) {
    $('#multiple_contact_update .multiple_update_sub_select').hide();
    $('#multiple_contact_update input[type=submit]').hide();

    if($('#multiple_update_action').val() !== '') {
      $('#' + $('#multiple_update_action').val() + '.multiple_update_sub_select').fadeIn();
      $('#multiple_contact_update input[type=submit]').val($('#multiple_contact_update .multiple_update_sub_select:visible').attr('data-button-text'));
      $('#multiple_contact_update input[type=submit]').fadeIn();
    }
  });

  $('#multiple_update_action').val('');
  $('#multiple_contact_update form input[type=submit]').enable();

  $('#multiple_contact_update input[type=submit]').click(function(e) {
    if(typeof $('#contacts_to_update').val() === 'undefined' || $('#contacts_to_update').val() == '') {
      alert('You must select contacts to perform the action on!');
      e.preventDefault();
    }
  });

});

function adjustToCampus() {
  $('#assigned_to_').fadeOut(function() {
    $('#assigned_to_').find('option').remove();
    $('#spinnerAssignedToSelect').fadeIn();
  });
  
  $.ajax({
      success: function(data) {
        fillAssignees(data);
        $('#spinnerAssignedToSelect').fadeOut(function() {
          $('#assigned_to_').fadeIn();
        });
      },
      data: 'campus_id=' + $('#campus_id').val(),
      dataType:'script',
      type:'post',
      url:'/contacts/assignees_for_campus'}); 
}

function fillAssignees(data) {
  try {
    $.each($.parseJSON(data), function(key, value) {
      opt = $("<option></option>").attr("value", value.id).text(value.name);
      if(value.selected === true) {
        opt.attr("selected", "selected");
      } else {
        opt.removeAttr("selected");
      }
      $('#assigned_to_').append(opt);
    });

    if($('#assigned_to_').val() == null) {
      $('#assigned_to_ option[value=-1]').attr("selected", "selected");
    }
  } catch (e) {
      // not json
  }
}