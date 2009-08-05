require_model 'user'

class User < ActiveRecord::Base
  has_one :access, :foreign_key => :viewer_id
  has_many :persons, :through => :access

  def created_at=(v) end

  def person
    persons.first
  end

  def username=(val)
    # don't let usernames be set to viewer_userID
  end

  def password() '' end
  def password=(val) '' end

  def login_callback
    person.sync_cim_hrdb
  end

  def self.find_or_create_from_cas(ticket)
    debugger
    # Look for a user with this guid
    receipt = ticket.response
    atts = receipt.extra_attributes
    guid = att_from_receipt(atts, 'ssoGuid')
    first_name = att_from_receipt(atts, 'firstName')
    last_name = att_from_receipt(atts, 'lastName')
    u = User.find(:first, :conditions => _(:guid, :user) + " = '#{guid}'")

    # if we have a user by this method, great! update the email address if it doesn't match
    if u
      u.person.email = receipt.user
    else
      # If we didn't find a user with the guid, do it by email address and stamp the guid
      u = User.find(:first, :conditions => { 
        _(:username, :user) => [ receipt.user.upcase, receipt.user.downcase ],
        _(:guid, :user) => "" # check for hijacking
      })
           
      unless u
        # try by person email
        p = Person.find(:first, :conditions => "#{_(:email, :person)} = '#{receipt.user.upcase}' or #{_(:email, :person)} = '#{receipt.user.downcase}'")
        #p = Person.find(:all).select{|p| p.email == reciept.user.upcase || p.email == reciept.user.downcase}.first
        u = p.user if p
        u = nil unless u && u.guid = "" # check for hijacking
      end

      if u
        u.guid = guid
        u.save!
      else
        # If we still don't have a user in SSM, we need to create one.
        #u = User.create!(:username => receipt.user, :guid => guid)
        Person.create_new_cim_hrdb_account guid, first_name, 
          last_name, receipt.user
      end
    end 
    u
  end
end
