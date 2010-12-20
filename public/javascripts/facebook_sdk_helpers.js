
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
