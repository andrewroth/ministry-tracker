class EmailMailer < ActionMailer::Base
  def email(person, email)
    @recipients  = person.primary_email
    @from        = "'#{email.sender.full_name}' <#{email.sender.primary_email}>"
    @subject     = email.subject
    @sent_on     = Time.now
    @body[:person] = person
    @body[:email] = email
  end
  
  def report(email, missing)
    @recipients  = email.sender.primary_email
    @from        = "'Campus Movement Tracker' <noreply@ministrytracker.org>"
    @subject     = "[MT] Email sent on your behalf"
    @sent_on     = Time.now
    @body = {:email => email, :missing => missing}
  end

end
