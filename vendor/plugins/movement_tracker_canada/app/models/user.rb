require_model 'user'

class User < ActiveRecord::Base
  has_one :access, :foreign_key => :viewer_id
  has_many :persons, :through => :access
  has_many :assignments, :foreign_key => :person_id

  def person
    persons.first
  end

  def username=(val)
    # don't let usernames be set to viewer_userID
  end

  def password() '' end
  def password=(val) '' end

  def login_callback
    setup_mt_roles_based_on_cim_hrdb
  end

  def setup_mt_roles_based_on_cim_hrdb
    create_involvements_for_assignments
  end

  protected

    def create_involvements_for_assignments
      for a in assignments
        a.assignment
      end
    end

    def setup_c4c_involvement
      c4c = Ministry.find_by_name 'Campus for Christ'
      person.ministry_involvements.create! :ministry_id => c4c.id
      person.ministry_involvements.save!
    end
end
