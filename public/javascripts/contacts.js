$(document).ready(function(){
	$('input[name="contact[]"]').change( function(){
		var contact_array = Array();
		$('input[name="contact[]"]').each(function(index){
			if( $(this).is(':checked') ) contact_array.push($(this).val());
		});
		$('#contacts_to_assign').val(contact_array.join());
	});
	$('#select_all').change( function(){
		$('input[name="contact[]"]').each(function(index){
			$(this).attr('checked', $('#select_all').is(':checked'));
		});
	});
});