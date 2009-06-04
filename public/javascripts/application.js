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

function serialize_array(obj)
{
    var string = '';

    if (typeof(obj) == 'object') {
        if (obj instanceof Array) {
            string = 'a:';
            tmpstring = '';
            count = 0;
            for (var key in obj) {
                tmpstring += serialize_array(key);
                tmpstring += serialize_array(obj[key]);
                count++;
            }
            string += count + ':{';
            string += tmpstring;
            string += '}';
        } else if (obj instanceof Object) {
            classname = obj.toString();

            if (classname == '[object Object]') {
                classname = 'StdClass';
            }

            string = 'O:' + classname.length + ':"' + classname + '":';
            tmpstring = '';
            count = 0;
            for (var key in obj) {
                tmpstring += serialize_array(key);
                if (obj[key]) {
                    tmpstring += serialize_array(obj[key]);
                } else {
                    tmpstring += serialize_array('');
                }
                count++;
            }
            string += count + ':{' + tmpstring + '}';
        }
    } else {
        switch (typeof(obj)) {
            case 'number':
                if (obj - Math.floor(obj) != 0) {
                    string += 'd:' + obj + ';';
                } else {
                    string += 'i:' + obj + ';';
                }
                break;
            case 'string':
                string += 's:' + obj.length + ':"' + obj + '";';
                break;
            case 'boolean':
                if (obj) {
                    string += 'b:1;';
                } else {
                    string += 'b:0;';
                }
                break;
        }
    }

    return string;
}

function show_spinner() 
{
  $("#spinner").show();
}

function hide_spinner()
{
  $("#spinner").hide();
}
