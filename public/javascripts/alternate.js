// Alternate yes/no for the hidden field corresponding to a checkbox
function alternate(elem) {
	if ($(elem).val() == 'yes') {
		$(elem).val('no');
	} else {
		$(elem).val('yes');
	}
}