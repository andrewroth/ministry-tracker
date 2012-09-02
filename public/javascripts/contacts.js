$(document).ready(function(){
  $('input[name="contact[]"]').change( function(){
    var contact_array = Array();
    $('input[name="contact[]"]').each(function(index){
      if( $(this).is(':checked') ) contact_array.push($(this).val());
    });
    $('#contacts_to_assign').val(contact_array.join());
  });

  $('#assign_people form input[type=submit]').enable();
  
  $('#select_all').change( function(){
    $('input[name="contact[]"]').each(function(index){
      $(this).attr('checked', $('#select_all').is(':checked'));
    });
  });

  $('#campus_id').change( function() {
    adjustToCampus();
    $('a.report_link').attr('href', '/contacts/impact_report?campus_id=' + $('#campus_id').val() );
  });

  adjustToCampus();
});

function adjustToCampus() {
  $('#assigned_to_').hide();
  $('#assigned_to_').find('option').remove();
  $('#spinnerAssignedToSelect').show();
  
  $.ajax({
      success: function(data) {
        fillAssignees(data);
        $('#spinnerAssignedToSelect').hide();
        $('#assigned_to_').show();
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
      }
      $('#assigned_to_').append(opt);
    });
  } catch (e) {
      // not json
  }
}