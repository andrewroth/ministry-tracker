class ContactMailer < ActionMailer::Base
  def assigned_contacts_email(contacts, base_url)
    @body[:person] = contacts.first.person
    @body[:contacts] = contacts
    @body[:base_url] = base_url
    @recipients   = @body[:person].email
    @from         = Cmt::CONFIG[:email_from_address]
    @subject      = "#{I18n.t("misc.email_prefix")}You have #{contacts.length > 1 ? "#{contacts.length} new contacts" : 'one new contact'} assigned to you for follow-up!"
    @sent_on      = Time.now
  end
end