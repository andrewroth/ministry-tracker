
function facebookOAuthRequest(redirect, permissions) {
  FB.login(function(response) {
    if (response.session) {
      if (response.perms) {
        // user is logged in and granted some permissions.
        // perms is a comma separated list of granted permissions
        alert("user is logged in and granted some permissions.");
        alert(response.perms);
      } else {
        // user is logged in, but did not grant any permissions
        alert("user is logged in, but did not grant any permissions");
      }
    } else {
      // user is not logged in
      alert("user is not logged in");
    }
    if (redirect != undefined) { window.location = redirect; }
  }, {perms:permissions});
}
