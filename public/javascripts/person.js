// Alternate yes/no for the hidden field corresponding to a checkbox
function alternate(elem) {
	if($(elem).value == 'yes') {
		$(elem).value = 'no';
	} else {
		$(elem).value = 'yes';
	}
}


$(function() {
	// Make rows in directory link to profiles
	$('.person_row').click(function() {
		document.location = $(this).attr('person_link');
	});
	
	// Toggle checkboxes
	$('#select_all').click(function() {
		$("form#people_form INPUT:checkbox").attr('checked', $('#select_all').is(':checked'));
		if($('#select_all').is(':checked')) {
			if($("form#people_form INPUT[@name=person[]]:checkbox:checked").length < total_people) {
				$('#selected_row').show();
			}
		}
	});
});

// Submit selected checkboxes and action
function performAction() {
	if($('#perform_action').val() != '') {
		if($("form#people_form INPUT[@name=person[]]:checkbox:checked").length > 0) {
      $('#spinner_perform_action').show();
			$('#people_form').attr('action', $('#perform_action').val());
			$('#people_form').submit();
		} else {
			alert("Please check at least one person to perform that action on.")
			$('#perform_action').val('');
		}
	}
}

function selectEntireSearch() {
	$('#entire_search').val(1);
	$('#selected_row').hide();
	$('#entire_search_row').show();
}

function clearSelection() {
	$('#entire_search').val(0);
	$("form#people_form INPUT:checkbox").attr('checked', false);
	$('#selected_row').hide();
	$('#entire_search_row').hide();
}