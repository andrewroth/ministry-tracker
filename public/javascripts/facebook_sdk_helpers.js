
// http://stackoverflow.com/questions/2253702/controlling-scroll-position-for-facebook-iframe-applications-parent-frame
function scrollTo(x,y){
  $("body").append('<iframe id="scrollTop" style="border:none;width:1px;height:1px;position:absolute;top:-10000px;left:-100px;" src="http://static.ak.facebook.com/xd_receiver_v0.4.php?r=1#%7B%22id%22%3A0%2C%22sc%22%3Anull%2C%22sf%22%3A%22%22%2C%22sr%22%3A2%2C%22h%22%3A%22iframeOuterServer%22%2C%22sid%22%3A%220.957%22%2C%22t%22%3A0%7D%5B0%2C%22iframeInnerClient%22%2C%22scrollTo%22%2C%7B%22x%22%3A'+x+'%2C%22y%22%3A'+y+'%7D%2Cfalse%5D" onload="$(\'#scrollTop\').remove();"></iframe>');
}

function facebookOAuthRequest(redirect, permissions) {
  FB.login(function(response) {
    if (response.session) {
      if (response.perms) {
        // user is logged in and granted some permissions.
        // perms is a comma separated list of granted permissions
      } else {
        // user is logged in, but did not grant any permissions
      }
    } else {
      // user is not logged in
    }
    if (redirect != undefined) { window.location = redirect; }
  }, {perms:permissions});
}

function setValueIfNotSet(inputID, newValue) {
  e = document.getElementById(inputID);

  if(e.value.trim() == "") {
    e.value = newValue;
  }
}

if(typeof(String.prototype.trim) === "undefined")
{
  String.prototype.trim = function()
  {
    return String(this).replace(/^\s+|\s+$/g, '');
  };
}
