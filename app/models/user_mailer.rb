class UserMailer < ActionMailer::Base
  def created_student(user, ministry, added_by, password = nil)
    created(user, ministry, added_by, password)
  end
  
  def created_staff
    created(user, ministry, added_by, password)
  end
  
  protected
  def created(user, ministry, added_by, password)
    @recipients  = user.username
    @from        = "'Ministry Tracker' <noreply@ministrytracker.org>"
    @subject     = "[MT] An account has been created for you"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:password] = password || user.plain_password
    @body[:ministry] = ministry
    @body[:added_by] = added_by
  end
end
