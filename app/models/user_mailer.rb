# Sends an email to a user after creation of a new account
class UserMailer < ActionMailer::Base
  def created_student(person, ministry, added_by, password = nil)
    password ||= person.user.plain_password
    if password.empty?
      # We need a password
      raise StandardError, 'No password for email'
    end
    created(person, ministry, added_by, password)
  end
  
  def confirm_email(email)
    @recipients  = "#{email}"
    from         = Cmt::CONFIG[:email_from_address]
    @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} Email confirmation code"
    @sent_on     = Time.now
    @body[:code] = User.secure_digest(email)
  end
  # 
  # def created_staff(person, ministry, added_by, password = nil)
  #   created(person, ministry, added_by, password)
  # end
  
  protected
  def created(person, ministry, added_by, password)
    @recipients  = person.user.username
    from         = Cmt::CONFIG[:email_from_address]
    @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} An account has been created for you"
    @sent_on     = Time.now
    @body[:person] = person
    @body[:user] = person.user
    @body[:password] = password || person.user.plain_password
    @body[:ministry] = ministry
    @body[:added_by] = added_by
  end
end
