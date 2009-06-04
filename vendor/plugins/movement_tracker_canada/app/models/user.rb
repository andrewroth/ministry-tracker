require_model 'user'

class User < ActiveRecord::Base
  has_one :access, :foreign_key => :viewer_id
  has_many :persons, :through => :access

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
end
