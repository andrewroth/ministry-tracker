// Alternate yes/no for the hidden field corresponding to a checkbox
function alternate(elem) {
  if($(elem).value == 'yes') {
    $(elem).value = 'no';
  } else {
    $(elem).value = 'yes';
  }
}

// Submit selected checkboxes and action
function performAction() {
  if ($('form#people_form input[name="person[]"]:checkbox:checked').length > 0) {

    var action = $('#perform_action').val();
    try {
      var parsedAction = $.parseJSON(action);
    } catch (e) {
    }

    if (typeof parsedAction !== 'undefined' && typeof parsedAction.jsFunction !== 'undefined') {
      parsedAction.jsFunction(parsedAction.options);

    } else if (action !== '') {
      submitPerformActionForm(action);
    }

  } else {
    alert("Please check at least one person to perform that action on.")
    $('#perform_action').val('');
  }
}

function submitPerformActionForm(action, remote) {
  $('#spinner_perform_action').show();
  $('#people_form').attr('action', action);

  if ( remote === true ) {
    $.ajax({
      type: 'POST',
      url: action,
      data: $("#people_form").serialize(),
      dataType: 'script'
    });

  } else {
    $('#people_form').submit();
  }
}

function setupLabelForm(options) {
  $('#directoryLabelForm').find('select').val('');
  $('#directoryLabelForm').find('option:first').html(options.prompt);
  $('#directoryLabelForm').find('select').on('change', function() {
    submitPerformActionForm(options.action, true);
  });

  $('select#perform_action').fadeOut(function() {
    $('#directoryLabelForm').fadeIn();
  });
}

function selectEntireSearch() {
  $('#entire_search').val(1);
  $('#selected_row').hide();
  $('#entire_search_row').show();
}

function clearSelection() {
  $('#entire_search').val(0);
  $("form#people_form input:checkbox").attr('checked', false);
  $('#selected_row').hide();
  $('#entire_search_row').hide();
}


// Used to dynamically add labels to a person's profile
function performLabelAdd() {
  if($('#label').val() != '') {
    $('#label').fadeOut('fast', function() {
      $('#spinnerlbls').fadeIn('fast');
    });

    $.ajax({
      data: jQuery.param($('#label_add_form').serializeArray()),
      dataType: 'script',
      type: 'post',
      url: $("#label_add_form").attr('action'),
      success: function() {
        $('#spinnerlbls').fadeOut(function() {
          $('#label').fadeIn();
        });
      }
    });
  }
}


function recruiterSearchBoxResultAction(event, info) {
  event.preventDefault();

  $('#recruitment_recruiter_id').val($(".autoCompleteInfo", info[0]).attr('person_id'));
  $('#recruitment_recruiter_id').change();

  $(event.target).blur();
}



$(function() {
  // Make rows in directory link to profiles
  $('.person_row').click(function() {
    document.location = $(this).attr('person_link');
  });

  // Toggle checkboxes
  $('#select_all').click(function() {
    $("form#people_form input:checkbox").attr('checked', $('#select_all').is(':checked'));
    if($('#select_all').is(':checked')) {
      if($('form#people_form input[name="person[]"]:checkbox:checked').length < total_people) {
        $('#selected_row').show();
      }
    }
  });

  $('#personLabels #label').val('');


  // Recruitment form
  $('form.edit_recruitment input, form.edit_recruitment select').not('.skip_submit_on_change').on('change', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  $('form.edit_recruitment').on('submit', function(e) {
    e.preventDefault();

    $('#recruitment_spinner_container .saved').hide();
    $('#recruitment_spinner_container #spinnerrecruitment').show();

    $form = $(this);
    $form.find('#submit_time').val(Date.now());
    $('#recruitment_spinner_container').removeClass();
    $('#recruitment_spinner_container').addClass($form.find('#submit_time').val());

    return true;
  });

  // don't submit form when enter is pressed
  $("form.edit_recruitment").bind("keypress", function(e) {
    if (e.keyCode == 13) { return false; }
  });

});