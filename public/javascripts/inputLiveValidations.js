$(document).ready(function(){
  	
	function pureInteger(s) {
		res = "";
		stopCollecting = false;
		for(i = 0; i < s.length; i++)
		{
			c = s.charAt(i);
			if(c == "." || c == ",") stopCollecting = true
			if(c >= "0" && c <= "9" && !stopCollecting) res += c;
		}
		if(!res) res = "0";
		return res;
	}

	function putBackslashes(s)
	{
		rC = /([\[\]])/g;
		if(rC.test(s)) s = s.replace(rC, "\\$1");
		return s;
	}

	function ErrorMessage(inputCtrl, message) {
		ctrlName = putBackslashes(inputCtrl.name);
		$("#message" + ctrlName).removeClass("jqueryValidationInformation").addClass("jqueryValidationError").html(message);
	}
	
	function InformativeMessage(inputCtrl, message) {
		ctrlName = putBackslashes(inputCtrl.name);
		$("#message" + ctrlName).removeClass("jqueryValidationError").addClass("jqueryValidationInformation").html(message);
	}

	function validDate(inputCtrl) {
		sdate = inputCtrl.value;
		valid = true;
		rVDate = /^(\d{4})[\/-](\d{1,2})[\/-](\d{1,2})$/g;
		rVDateN = /^(20\d{2})([01]\d{1})([0123]\d{1})$/g;
		if(rVDate.test(sdate)) sdate = sdate.replace(rVDate, "$1/$2/$3");
		else if(rVDateN.test(sdate)) sdate = sdate.replace(rVDateN, "$1/$2/$3");
		else valid = false;
		valid ? InformativeMessage(inputCtrl, "<img src=\"/images/silk/accept.png\"/>") : ErrorMessage(inputCtrl, "<img src=\"/images/silk/exclamation.png\" /> Invalid, use yyyy/mm/dd");
		inputCtrl.value = sdate;
	}
	
	function validRequired(inputCtrl)
	{
		valid = true;
		if(inputCtrl.value == "" || typeof inputCtrl.value  == "undefined") valid = false;
		valid ? InformativeMessage(inputCtrl, "<img src=\"/images/silk/accept.png\"/>") : ErrorMessage(inputCtrl, "<img src=\"/images/silk/exclamation.png\" /> required");
		return valid;
	}

  function submitValidateRequired(e)
  {
    fail = false;
    
    $("input.required, textarea.required, select.required").each(function ()
    {
      if(validRequired($(this)[0]) == false)
      {
        fail = true;
      }
    });
    
    if(fail == true)
    {
      alert(submitValidateRequiredFailMessage);
      e.preventDefault();
      return false;
    }
  }


  yyyymmddMessage = "(yyyy/mm/dd)";
  requiredMessage = "";
  submitValidateRequiredFailMessage = "Please fill all required fields";

  $("input.positiveinteger").change(function (e) { e.currentTarget.value = pureInteger(e.currentTarget.value); });
  $("input.yyyymmdd").blur(function (e) { validDate(e.currentTarget); });
  $("input.required").blur(function (e) { validRequired(e.currentTarget); });
  $("textarea.required").blur(function (e) { validRequired(e.currentTarget); });
  $("select.required").change(function (e) { validRequired(e.currentTarget); });
  $("select.required").blur(function (e) { validRequired(e.currentTarget); });
  
  $("input.submit.validateRequiredOnSubmit").click(function (e) { submitValidateRequired(e); });
  $(".jqueryValidationMessage.yyyymmdd").html(yyyymmddMessage);
  $(".jqueryValidationMessage.required").html(requiredMessage);

});
