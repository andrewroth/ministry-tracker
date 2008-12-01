class UserMailer < ActionMailer::Base
  def created_student(person, ministry, added_by, password = nil)
    password ||= person.user.plain_password
    if password.empty?
      # We need a password
      raise StandardError, 'No password for email'
    end
    created(person, ministry, added_by, password)
  end
  # 
  # def created_staff(person, ministry, added_by, password = nil)
  #   created(person, ministry, added_by, password)
  # end
  
  protected
  def created(person, ministry, added_by, password)
    @recipients  = person.user.username
    @from        = "'Ministry Tracker' <noreply@ministrytracker.org>"
    @subject     = "[MT] An account has been created for you"
    @sent_on     = Time.now
    @body[:person] = person
    @body[:user] = person.user
    @body[:password] = password || person.user.plain_password
    @body[:ministry] = ministry
    @body[:added_by] = added_by
  end
end
