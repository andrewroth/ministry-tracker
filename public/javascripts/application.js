function show_upload_picture() {
	tb_show('Upload Picture', '#TB_inline?width=300&height=300&inlineId=uploadPicture')
}

function show_add_student() {
	tb_show('Add Student', '#TB_inline?width=450&height=320&inlineId=addStudent')
}

function show_change_password() {
	tb_show('Change Password', '#TB_inline?width=450&height=300&inlineId=changePassword')
}

function close_thickbox() {
	tb_remove();
}
