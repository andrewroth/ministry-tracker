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

	$('#campus_id').change( function(){ adjustToCampus(); });
	adjustToCampus();
	
});

function adjustToCampus() {
	$('#assigned_to_').find('option').remove();
	$.ajax({
	    success: function(data) { fillAssignees(data) },
	    data: 'campus_id=' + $('#campus_id').val(),
	    dataType:'script',
	    type:'post',
	    url:'/contacts/assignees_for_campus'});	
}

function fillAssignees(data) {
	try {
	$.each($.parseJSON(data), function(key, value) {
		$('#assigned_to_')
			.append($("<option></option>")
			.attr("value",value.id)
			.text(value.name));
	});
	} catch (e) {
	    // not json
	}
} 
