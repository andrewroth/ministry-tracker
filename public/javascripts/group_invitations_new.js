
$(document).ready(function(){

  $("#invitationSearchForm").submit(function(e) {
    if (simpleValidateEmail($("#inviteSearchBox").val()) == null) {
      alert("Please type in an email address or choose someone from the list.");
    }
    else {
      addInviteEmail($("#inviteSearchBox").val());
      $("#inviteSearchBox").val("");
    }
    return false; // never actually submit this form
  });
  
  
  $("#invitationSubmit").click(function(){
    $("#spinner_submit").show();
  });
  
});


function groupInvitationSearchBoxResultAction(event, info) {
  event.preventDefault();
  addInviteEmail($(".autoCompleteInfo", info[0]).attr("email"),
                 $(".autoCompleteInfo", info[0]).attr("person_fname") + " " + $(".autoCompleteInfo", info[0]).attr("person_lname"));
  
  $("#inviteSearchBox").val("");
}


function addInviteEmail(email, pname) {

  email_already_added = false;
  $("#invitations > input").each(function() {
    if(email == $(this).attr("value")) { email_already_added = true; }
  });
  
  if(email_already_added == false){
    i = $("#invitations > input").size();
    
    $("#invitations").append("<input type='hidden' value='"+email+"' name='group_invitations["+i+"][email]' id='group_invitations_"+i+"_email'>");

    display = ""
    if(pname != null && pname != "") { display += " "+pname+" &lt;"+email+"&gt;" }
    else { display += " "+email }
    
    $("#invitationsDisplay").append("<span id='groupInvitationDisplay"+i+"'>" + display + " <a class='removeInvitationLink' i='"+i+"' href='' title='Remove'>×</a><br/></span>").effect("highlight", {}, 1000);
  }
  else if(email_already_added == true) {
    alert("You've already added "+email+"!");
  }


  $("a.removeInvitationLink").click(function(e) {
    e.preventDefault();
    i = $(this).attr("i");
    $("#group_invitations_"+i+"_email").remove();
    $("#groupInvitationDisplay"+i).remove();
  });
}
