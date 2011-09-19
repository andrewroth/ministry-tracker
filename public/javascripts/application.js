function show_upload_picture() {
	tb_show('Change Picture', '#TB_inline?width=300&height=200&inlineId=uploadPicture')
}

// use as a general dialog utility
function show_dialog(title, w, h) {
  if (w == null) { w = '450' }
  if (h == null) { h = '320' }
  tb_show(title, "#TB_inline?width="+w+"&height="+h+"&inlineId=dialog")
}

function show_add_student() {
	show_dialog('Add Student');
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

function simpleValidateEmail(email) { 
  var re = /\S+@\S+\.\S+/;
  return email.match(re);
}
  
function strikeParentOnHover(e) {
  e.hover(function(){$(this).parent().css("text-decoration", "line-through")}, function(){$(this).parent().css("text-decoration", "none")});
}

function disableInputsOnSubmit(theClass) {
  $("form.disableOnSubmit").submit(function(){
    $("input.disableOnSubmit").attr('disabled', 'disabled');
  });
  
  $(document).ready(function() {
    $("input.disableOnSubmit").removeAttr('disabled');
  });
}

