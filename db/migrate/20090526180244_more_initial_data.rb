class MoreInitialData < ActiveRecord::Migration

  def self.username(r, m)
    "#{r.name.underscore.gsub(' ','_')}@#{m.name}.com"
  end

  def self.first_name(r)
    r.name.camelize.gsub(' ','')
  end

  def self.up
    unless RAILS_ENV == 'development'
      puts "Warning: rails environment is not development, so test users per role were not created."
      return
    end

    # when migrating from scratch to this point all at once, the column
    # information gets FUBARed
    User.reset_column_information
    Person.reset_column_information
    MinistryRole.reset_column_information
    MinistryInvolvement.reset_column_information

    # make two new ministries
    tl = Ministry.find_by_name('Top Level')
    a = Ministry.create! :parent_id => tl.id, :name => "foo"
    b = Ministry.create! :parent_id => tl.id, :name => "bar"
    
    # create a bunch of users
    for m in [a, b]
      for r in MinistryRole.find :all, :order => :position
        u = User.create!(User._(:username) => username(r,m),
                            User._(:plain_password) => 'testuser', 
                            User._(:password_confirmation) => 'testuser')
        p = Person.create(Person._(:first_name) => first_name(r),
                          Person._(:last_name) => 'User', 
                          Person._(:user_id) => u.id )
        MinistryInvolvement.create(:person_id => p.id, 
                                   :ministry_id => m.id, 
                                   :ministry_role_id => r.id, 
                                   :admin => false)
        puts "Created #{u.username}"
      end
    end
  end

  def self.down
    unless RAILS_ENV == 'development'
      puts "Warning: rails environment is not development, so test users per role were not created."
      return
    end

    tl = Ministry.find_by_name('Top Level')
    a = Ministry.find_by_name 'foo'
    b = Ministry.find_by_name 'bar'
   
    for m in [a, b]
      for r in MinistryRole.find :all, :order => :position
        u = User.find :first, :conditions => [ "#{User._(:username)} = ?", username(r,m) ]
        p = Person.find :first, :conditions => [ "#{Person._(:first_name)} = ?", first_name(r) ]
        puts "Destroying #{u.username}"
        p.ministry_involvements.delete_all
        p.destroy
        u.destroy
      end
    end

    a.destroy
    b.destroy
  end
end
