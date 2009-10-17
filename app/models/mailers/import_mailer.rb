class Mailers::ImportMailer < ActionMailer::Base
  def complete(person, successful, unsuccessful)
    @recipients  = person.primary_email
    @from        = "'Campus Movement Tracker' <noreply@ministrytracker.org>"
    @subject     = "[MT] Email sent on your behalf"
    @sent_on     = Time.now
    @body        = {:person => person, :successful => successful, :unsuccessful => unsuccessful}
  end
end
