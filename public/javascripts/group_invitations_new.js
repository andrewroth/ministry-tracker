
$(document).ready(function(){

  $("#invitationSearchForm").submit(function(e) {
    if (simpleValidateEmail($("#inviteSearchBox").val()) == null) {
      alert("Please type in an email address or choose someone from the list.");
    }
    else {
      addInviteEmail($("#inviteSearchBox").val());
      $("div.ac_results_group_invite").hide();
      $("#inviteSearchBox").val("");
    }
    return false; // never actually submit this form
  });


  $("#invitationSubmit").click(function() {
    if (simpleValidateEmail($("#inviteSearchBox").val()) != null) {
      $("#invitationSearchForm").submit();
    }

    if($("#invitations input").size() > 0) {
      $("#spinner_submit").show();
    }
    else {
      alert("You didn't choose anyone to invite. Use the search to find a friend or just type in their email and press enter.");
      return false;
    }
  });

});


function groupInvitationSearchBoxResultAction(event, info) {
  $('#inviteSearchBox').addClass('preventSubmit');

  addInviteEmail($(".autoCompleteInfo", info[0]).attr("email"),
                 $(".autoCompleteInfo", info[0]).attr("person_fname") + " " + $(".autoCompleteInfo", info[0]).attr("person_lname"));

  $("#inviteSearchBox").val("");
}


function addInviteEmail(email, pname) {

  email_already_added = false;
  $("#invitations > input").each(function() {
    if(email.toLowerCase() == $(this).attr("value").toLowerCase()) { email_already_added = true; }
  });

  if(email_already_added == false){
    i = $("#invitations > input").size();

    $("#invitations").append("<input type='hidden' value='"+email+"' name='group_invitations["+i+"][email]' id='group_invitations_"+i+"_email'>");

    display = ""
    if(pname != null && pname != "") { display += " "+pname+" &lt;"+email+"&gt;" }
    else { display += " "+email }

    $("#invitationsDisplay").append("<span id='groupInvitationDisplay"+i+"'>" + display + " <a class='removeInvitationLink' i='"+i+"' href='' title='Remove'>×</a><br/></span>").effect("highlight", {}, 1500);
  }

  $("a.removeInvitationLink").click(function(e) {
    e.preventDefault();
    i = $(this).attr("i");
    $("#group_invitations_"+i+"_email").remove();
    $("#groupInvitationDisplay"+i).remove();
  });
}
