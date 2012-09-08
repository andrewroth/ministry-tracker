class ContactMailer < ActionMailer::Base

  def assigned_contacts_email(contacts, base_url)
    person = contacts.first.person
    
    @body[:person] = {:first_name => person.first_name, :id => person.id, :email => person.email}
    @body[:contacts] = contacts.collect { |c| {:first_name => c.first_name, :last_name => c.last_name, :id => c.id, :priority => c.priority} }
    @body[:contacts_length] = contacts.length
    @body[:contact_campus] = contacts.first.campus.short_name
    @body[:base_url] = base_url

    @recipients   = @body[:person][:email]
    @from         = Cmt::CONFIG[:email_from_address]
    @subject      = "#{I18n.t("misc.email_prefix")}You have #{contacts.length > 1 ? "#{contacts.length} new contacts" : 'one new contact'} assigned to you for follow-up!"
    @sent_on      = Time.now
  end

end