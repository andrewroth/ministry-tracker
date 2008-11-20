require 'digest/md5'
require 'base64'
class User < ActiveRecord::Base
  load_mappings
  # Virtual attribute for the unencrypted password
  attr_accessor :plain_password, :password_confirmation

  # validates_format_of       :username, :message => "must be an email address", :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of       :username,    :within => 6..40
  validates_uniqueness_of   :username, :case_sensitive => false, :on => :create
  before_save :encrypt_password
  before_create :stamp_created_on
  
  has_one :person, :class_name => 'Person', :foreign_key => _(:user_id, :person)
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :username, :plain_password, :password_confirmation, :guid
  
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

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
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
  
  def self.find_or_create_from_cas(receipt)
    # Look for a user with this guid
    u = User.find(:first, :conditions => _(:guid, :user) + " = '#{receipt.guid}'")
    # if we have a user by this method, great! update the email address if it doesn't match
    if u
      u.username = receipt.user_name
    else
      # If we didn't find a user with the guid, do it by email address and stamp the guid
      u = User.find(:first, :conditions => _(:username, :user) + " = '#{receipt.user_name}'")
      if u
        u.guid = receipt.guid
      else
        # If we still don't have a user in SSM, we need to create one.
        u = User.create!(:username => receipt.user_name, :guid => receipt.guid)
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
      
      # Attache the found person to the user, or create a new person
      u.person = person || Person.new(:first_name => receipt.first_name, :last_name => receipt.last_name)
      
      # Create a current address record if we don't already have one.
      u.person.current_address ||= CurrentAddress.new(:email => receipt.user_name)
      u.person.save(false)
    end
    u
  end
  protected
    # before filter 
    def encrypt_password
      # If the record doesn't have a password at all, assign one
      assign_random_password if password.blank?
      
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
    
    
end
