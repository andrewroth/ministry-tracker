require_model 'user'

class User < ActiveRecord::Base
  has_one :access, :foreign_key => :viewer_id
  has_many :persons, :through => :access
  has_many :accountadmin_accessgroups, :through => :accountadmin_vieweraccessgroup
  has_many :accountadmin_vieweraccessgroups, :foreign_key => :viewer_id
  has_many :accountadmin_accountadminaccesses
  belongs_to :accountadmin_accountgroup, :foreign_key => :accountgroup_id
  belongs_to :accountadmin_language, :foreign_key => :language_id

  validates_presence_of _(:last_login)
  validates_uniqueness_of _(:username), :case_sensitive => false, :message => "(username) has already been taken"

  MAX_SEARCH_RESULTS = 1000


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
        u.viewer_userID = receipt.user # force longer usernames by using their email
                                       # instead of silly short usernames; this is ok because
                                       # we don't support the accountadmin_viewer logins anymore
        u.guid = guid
        u.save!
      else
        # If we still don't have a user in SSM, we need to create one.
        #u = User.create!(:username => receipt.user, :guid => guid)
        u = Person.create_new_cim_hrdb_account guid, first_name, 
          last_name, receipt.user
      end
    end 

    # update last login and email in a way that won't break the rest of the login if it
    # doesn't work
    begin
      u.viewer_lastLogin = Time.now
      u.viewer_userID = receipt.user
      u.save!
    rescue
    end

    u
  end

  def human_is_active()
    return self.is_active == 0 ? "no" : "yes"
  end
end
