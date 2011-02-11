class Mailers::EmailMailer < ActionMailer::Base
  def email(person, email)
    recipients   person.primary_email.strip
    from         "<#{email.sender.primary_email}>"
    @subject     = email.subject
    @sent_on     = Time.now
    @body[:person] = person
    @body[:email] = email
  end
  
  def report(email, missing, errors)
    recipients   email.sender.primary_email.strip
    from         Cmt::CONFIG[:email_from_address]
    @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} Email sent on your behalf"
    @sent_on     = Time.now
    @body = {:email => email, :missing => missing, :errors => errors}
  end

  def emails_working(emails)
    recipients   emails
    from         Cmt::CONFIG[:email_from_address]
    @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} Emails still working"
    @sent_on     = Time.now
  end
end
