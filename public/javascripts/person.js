// Alternate yes/no for the hidden field corresponding to a checkbox
function alternate(elem) {
	if($(elem).value == 'yes') {
		$(elem).value = 'no';
	} else {
		$(elem).value = 'yes';
	}
}


// Make rows in directory link to profiles
$(function() {
	$('.person_row').click(function() {
		document.location = $(this).attr('person_link');
	})
});