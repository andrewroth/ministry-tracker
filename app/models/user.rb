require 'zlib'
require 'digest/md5'
require 'base64'
class User < ActiveRecord::Base
  include Authentication
  
  load_mappings
  # Virtual attribute for the unencrypted password
  attr_accessor :plain_password, :password_confirmation

  # validates_format_of       :username, :message => "must be an email address", :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of       _(:username), :within => 6..40
  validates_uniqueness_of   _(:username), :case_sensitive => false, :on => :create
  before_save :encrypt_password, :create_facebook_hash
  before_create :stamp_created_on
  after_create :register_user_to_fb

  
  has_one :person, :class_name => 'Person', :foreign_key => _(:user_id, :person)
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :username, :plain_password, :password_confirmation, :guid, :facebook_username, :last_login, :fb_user_id, :facebook_hash

  #liquid_methods :created_at
  def to_liquid
    { "created_at" => created_at }
  end

  # Make sure password and confirm_password are the same on update
  def validate_on_update
    unless plain_password.blank?
      unless plain_password == password_confirmation
        errors.add_to_base("Passwords don't match")
      end
      # Validate password criteria
      unless plain_password.length >= 6
        errors.add_to_base("Password must be at least 6 characters long.")
      end
    end
  end
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, plain_password)
    u = find(:first, :conditions => _(:username) + " = '#{login}'")
    u && u.authenticated?(plain_password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(plain_password)
    md5_password = Digest::MD5.digest(plain_password)
  	base64_password = Base64.encode64(md5_password).chomp
  	base64_password
  end

  # Encrypts the password with the user salt
  def encrypt(plain_password)
    self.class.encrypt(plain_password)
  end

  def authenticated?(plain_password)
    password == encrypt(plain_password)
  end

  # Remember token remembers users between browser closures
  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between
  # browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{username}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    u = User.find(:first, :conditions => {_(:fb_user_id, :user)  => fb_user.uid}) ||  User.find(:first, :conditions => {_(:facebook_hash, :user)  => fb_user.email_hashes}) 
    # make sure we have a person
    if u && !u.person
      u.create_person_from_fb(fb_user)
    end
    u.update_attribute(:fb_user_id, fb_user.uid) if u && !u.fb_user_id
    u
  rescue Facebooker::Session::SessionExpired
    nil
  end
  
  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user, username = nil)
    u = User.find(:first, :conditions => {_(:username, :user) => username} ) if username
    if u
      u.facebook_hash = fb_user.email_hashes.first
      u.fb_user_id = fb_user.uid
      u.username = username if username
    else
      u = User.create(_(:username) => username || fb_user.email_hashes.first, _(:last_login) => Time.zone.now, _(:fb_user_id) => fb_user.uid, _(:facebook_hash) => fb_user.email_hashes.first)
    end
    u.create_person_from_fb(fb_user) unless u.person
    u.save(false)
    u
  end
  
  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      #merge the existing account
      unless existing_fb_user.nil?
        merge_with(existing_fb_user)
      end
      #link the new one
      self.fb_user_id = fb_user_id
      save(false)
    end
  end
  
  def create_person_from_fb(fb_user)
    # Attach the found person to the user, or create a new person
    new_person = Person.new(_(:first_name, :person) => fb_user.first_name, _(:last_name, :person) => fb_user.last_name)
    self.person = new_person
    
    # Create a current address record if we don't already have one.
    person.current_address ||= CurrentAddress.new(_(:city, :address) => fb_user.current_location.city,
                                                  _(:country, :address) => CmtGeo.lookup_country_code(fb_user.current_location.country),
                                                  _(:state, :address) => Carmen::state_name(fb_user.current_location.state))
    person.save(false)
  end
  
  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We then use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    email = facebook_username.present? ? facebook_username : username
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.facebook_hash = Facebooker::User.hash_email(email)
    save(false)
  end
  
  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
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
      u.username = receipt.user
    else
      # If we didn't find a user with the guid, do it by email address and stamp the guid
      u = User.find(:first, :conditions => _(:username, :user) + " = '#{receipt.user}'")
      if u
        u.guid = guid
      else
        # If we still don't have a user in SSM, we need to create one.
        u = User.create!(:username => receipt.user, :guid => guid)
      end
    end            
    # Update the password to match their gcx password too. This will save a round-trip later
    # u.plain_password = params[:plain_password]
    u.save(false)
    # make sure we have a person
    unless u.person
      # Try to find a person with the same email address who doesn't already have a user account
      address = CurrentAddress.find(:first, :conditions => _(:email, :address) + " = '#{u.username}'")
      person = address.person if address && address.person.user.nil?
      
      # Attach the found person to the user, or create a new person
      new_person = first_name ? Person.new(:first_name => first_name, :last_name => last_name) : Person.new
      u.person = person || new_person
      
      # Create a current address record if we don't already have one.
      u.person.current_address ||= CurrentAddress.new(:email => receipt.user)
      u.person.save(false)
    end
    u
  end
  
  protected
    # not sure why but cas sometimes sends the extra attributes as underscored
    def self.att_from_receipt(atts, key)
      atts[key] || atts[key.underscore]
    end

    # before filter 
    def encrypt_password
      # If the record doesn't have a password at all, assign one
      assign_random_password if password.blank? && plain_password.blank?
  
      # If the password isn't being provided at this time, there's nothing to encrypt
      return if plain_password.blank?
      self.password = encrypt(plain_password)
    end

    def stamp_created_on
      self.created_at = Time.now
    end

    def assign_random_password(len = 8)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      self.plain_password = self.password_confirmation = newpass
    end
    
    def create_facebook_hash
      if changed.include?('username') || changed.include?('facebook_username')
        register_user_to_fb
      end
    end

end
