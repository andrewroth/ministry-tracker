// Alternate yes/no for the hidden field corresponding to a checkbox
function alternate(elem) {
	if($(elem).value == 'yes') {
		$(elem).value = 'no';
	} else {
		$(elem).value = 'yes';
	}
}