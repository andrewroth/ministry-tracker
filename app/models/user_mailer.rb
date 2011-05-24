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
    @recipients   = "#{email}"
    @from         = Cmt::CONFIG[:email_from_address]
    @subject      = "#{Cmt::CONFIG[:email_subject_prefix]} Email confirmation code"
    @sent_on      = Time.now
    @body[:code]  = User.secure_digest(email)
  end

  def signup_finished_email(email, link, joined_collection_group)
    @recipients   = "#{email}"
    @from         = Cmt::CONFIG[:email_from_address]
    @subject      = "#{Cmt::CONFIG[:email_subject_prefix]} Signup completed"
    @sent_on      = Time.now
    @content_type = "text/html"
    @body[:joined_collection_group] = joined_collection_group
    @body[:link]  = link
  end

  def signup_confirm_email(email, link)
    @recipients   = "#{email}"
    @from         = Cmt::CONFIG[:email_from_address]
    @subject      = "#{Cmt::CONFIG[:email_subject_prefix]} Your Pulse verify email"
    @sent_on      = Time.now
    @content_type = "text/html"
    @body[:link]  = link
  end

  def group_join_email(requested, interested, group_name, leader_first_name, leader_email, 
                       member_first_name, member_last_name, member_email, member_phone, 
                       join_time, school_year, group_link)
    @content_type = "text/html"
    @recipients  = leader_email
    @from        = Cmt::CONFIG[:email_from_address]
    if requested
      @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} #{group_name} has a student requesting to join!"
    elsif interested
      @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} #{group_name} has a student interested in it!"
    else
      @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} #{group_name} has a new member!"
    end
    @sent_on     = Time.now
    @body[:requested] = requested
    @body[:interested] = interested
    @body[:group_name] = group_name
    @body[:leader_first_name] = leader_first_name
    @body[:member_first_name] = member_first_name
    @body[:member_last_name] = member_last_name
    @body[:member_email] = member_email
    @body[:member_phone] = member_phone
    @body[:join_time] = join_time
    @body[:school_year] = school_year
    @body[:group_link] = group_link
  end

  def summer_report_submitted(review, base_url)
    @content_type = "text/html"
    @recipients = review.person.email
    @from = Cmt::CONFIG[:email_from_address]
    @subject = "#{Cmt::CONFIG[:email_subject_prefix]} #{review.summer_report.person.full_name} submitted summer schedule"
    @sent_on = Time.now

    @body[:reviewer_first_name] = review.person.first_name
    @body[:submitter_name] = review.summer_report.person.full_name
    @body[:review_link] = "#{base_url}/people/#{review.person_id}/summer_report_reviewers"
  end

  def summer_report_reviewed(summer_report, base_url)
    @content_type = "text/html"
    @recipients = summer_report.person.email
    @from = Cmt::CONFIG[:email_from_address]
    @sent_on = Time.now

    if summer_report.approved?
      @subject = "#{Cmt::CONFIG[:email_subject_prefix]} Your summer schedule was approved!"
    elsif summer_report.disapproved?
      @subject = "#{Cmt::CONFIG[:email_subject_prefix]} Your summer schedule was disapproved..."
    end

    @body[:summer_report] = summer_report
    @body[:submitter_first_name] = summer_report.person.first_name
    @body[:show_report_link] = "#{base_url}/people/#{summer_report.person_id}/summer_reports/#{summer_report.id}"
    @body[:edit_report_link] = "#{base_url}/people/#{summer_report.person_id}/summer_reports/new"
  end
  
  def group_invitation(group_invitation, base_url)
    @content_type = "text/html"
    @recipients = group_invitation.recipient_email
    @from = Cmt::CONFIG[:email_from_address]
    @sent_on = Time.now
    
    @subject = "#{Cmt::CONFIG[:email_subject_prefix]} #{group_invitation.sender_person.first_name} invites you to join #{group_invitation.group.name}"
    
    @body[:group_invitation] = group_invitation
    @body[:accept_link] =  "#{base_url}/groups/#{group_invitation.group_id}/group_invitations/#{group_invitation.id}/accept?login_code=#{group_invitation.login_code.code}"
    @body[:decline_link] = "#{base_url}/groups/#{group_invitation.group_id}/group_invitations/#{group_invitation.id}/decline?login_code=#{group_invitation.login_code.code}"
    @body[:other_groups_link] = "#{base_url}/signup?login_code=#{group_invitation.login_code.code}"
  end
  
  def group_invitation_decline(group_invitation, base_url)
    @content_type = "text/html"
    @recipients = group_invitation.recipient_email
    @from = Cmt::CONFIG[:email_from_address]
    @sent_on = Time.now
    
    @subject = "#{Cmt::CONFIG[:email_subject_prefix]} #{group_invitation.recipient_email} declined your invite to join #{group_invitation.group.name}"
    
    @body[:group_invitation] = group_invitation
  end
  

   # 
  # def created_staff(person, ministry, added_by, password = nil)
  #   created(person, ministry, added_by, password)
  # end
  
  protected
  def created(person, ministry, added_by, password)
    @recipients  = person.user.username
    @from         = Cmt::CONFIG[:email_from_address]
    @subject     = "#{Cmt::CONFIG[:email_subject_prefix]} An account has been created for you"
    @sent_on     = Time.now
    @body[:person] = person
    @body[:user] = person.user
    @body[:password] = password || person.user.plain_password
    @body[:ministry] = ministry
    @body[:added_by] = added_by
  end
end
