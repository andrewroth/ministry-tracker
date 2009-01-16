class User < ActiveRecord::Base
 attr_accessor :plain_password, :password_confirmation
end

class InitialData < ActiveRecord::Migration
  def self.up
    ministry = Ministry.find_by_name('Top Level')
    top_role = ministry.ministry_roles.find(:first, :order => Ministry._(:position))
    # 12: Campus Coordinator
    # 9: Ministry Leader (a student who oversees a campus, eg LINC leader)
    # 8: Missionary
    # 7: Student Leader
    # 6: Involved Student (we are saying has been attending events for at least 6 months)
    # 5: Student
    # 4: Registration Incomplete (A leader has registered them, but user has not completed rego and signed the privacy policy)
    # 3: Approval Pending (They have applied, but a leader has not verified their application yet)
    # 2: Honourary Member (not a valid student or missionary, but we are giving them limited access anyway)
    # 1: Admin

    # Create test user
    user = User.create!(:username => 'test.user@example.com', :plain_password => 'testuser', :password_confirmation => 'testuser')
    # XZxoxsUO09AqL89U9jmTtg==
    
    # Create person
    person = Person.create(Person._(:first_name) => 'Test', Person._(:last_name) => 'User', Person._(:user_id) => user.id )
    
    puts "person: #{person.inspect} minsitry: #{ministry.inspect} top_role: #{top_role.inspect}"
    MinistryInvolvement.create(:person_id => person.id, :ministry_id => ministry.id, :ministry_role_id => top_role.id, :admin => true)
    
  end

  def self.down
    ministry = Ministry.find(:first, :conditions => {Ministry._(:name) => 'Top Level'})
    ministry.destroy if ministry
    user = User.find(:first, :conditions => {User._(:username) => 'test.user@example.com'})
    user.destroy if user
    person = Person.find(:first, :conditions => {Person._(:user_id) => user.id})
    person.destroy if person
    Column.delete_all(["title in (?)", ['First Name','Last Name','Street','City','State','Zip','Email','Picture','Website']])
  end
end
