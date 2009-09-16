require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'


# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < ActionController::TestCase
  def setup
    login
  end
  
  test "full directory" do
    get :directory
    assert_response :success
    assert assigns(:people)
    assert_template('directory')
  end
  
  # def test_directory_download
  #   @request.env["HTTP_ACCEPT"] = "text/html"
  #   get :directory, :format => :xls
  #   assert_equal "text/html", @response.content_type
  #   assert_response 406
  #   assert assigns(:people)
  # end
  
  test "directory pagination" do
    post :directory, :search => 'all'
    assert_response :success
    assert assigns(:people)
  end
  
  test "A user should be able to see a directory a directory on a ministry with no campuses" do
    login('staff_on_ministry_with_no_campus')
    @request.session[:ministry_id] = ministries(:under_top).id #under_top is under top, which I am a member of
    get :directory
    assert_response :success
    assert assigns(:people)
  end
  
  test "A person with no campus involvements should still show in the directory" do
    login('staff_on_ministry_with_no_campus')
    session[:ministry_id] = ministries(:top).id
    get :directory
    assert ppl = assigns(:people)
    assert(ppl.detect {|p| p['person_id'].to_i == people(:staff_on_ministry_with_no_campus).id}, "staff_on_ministry_with_no_campus didn't show up.")
  end
  
  test "perform search by firstname" do
    post :directory, :search => 'josh'
    assert_response :success
    assert assigns(:people)
  end
  
  test "perform search by fullname" do
    post :directory, :search => 'josh starcher'
    assert_response :success
    assert assigns(:people)
  end
  
  test "perform search by email" do
    post :directory, :search => 'josh.starcher@uscm.org'
    assert_response :success
    assert assigns(:people)
  end
  
  test "directory paginate Z" do
    post :directory, :first => 'Z', :finish => ''
    assert_response :success
    assert assigns(:people)
  end
  
  test "search full name" do
    xhr :post, :search, :search => 'Josh Starcher', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end
  
  test "search first name" do
    xhr :post, :search, :search => 'Josh', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end
  
  test "search with no results" do
    get :search, :search => 'xyz', :context => 'group_involvements'
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should change view" do
    post :change_view, :view => '1'
    assert_redirected_to directory_people_path(:format => :html)
  end
  
  test "should clear session order when changing view" do
    get :directory, :order => Person._(:first_name)
    post :change_view, :view => '1'
    assert_redirected_to directory_people_path(:format => :html)
    assert_nil session[:order]
  end
  
  test "should re-create staff" do
    old_count = Person.count
    post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                  :current_address => {:email => "josh.starcher@uscm.org"},
                  :ministry_involvement => { :ministry_role_id => StaffRole.first.id },
                  :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
    assert_equal old_count, Person.count
    assert_redirected_to person_path(assigns(:person))
  end
  
  test "should create student" do
    assert_difference "Person.count" do
      post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => '1' }, 
                    :current_address => {:email => "josh.starcsher@gmail.org"}, 
                    :modalbox => 'true', 
                    :ministry_involvement => { :ministry_id => 1, :ministry_role_id => StudentRole.first.id }, 
                    :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
      assert person = assigns(:person)
      assert_not_nil person.user.id
      assert_redirected_to person_path(assigns(:person))
    end
  end
  
  # def test_should_create_student_with_username_conflict # Not likely to ever happen
  #   old_count = Person.count
  #   test_should_create_student
  #   post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
  #                 :current_address => {:email => "josh.starcher@gmail.org"}, :student => true
  #   assert person = assigns(:person)
  #   assert_equal old_count+1, Person.count
  #   assert_redirected_to person_path(assigns(:person))
  # end
  
  test "should re-create student" do
    assert_no_difference('Person.count') do
      post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                    :current_address => {:email => "josh.starcher@uscm.org"},
                    :ministry_involvement => { :ministry_role_id => StudentRole.first.id },
                    :campus_involvement => { :campus_id => 1, :school_year_id => 1 }
      assert person = assigns(:person)
    end
    assert_redirected_to person_path(assigns(:person))
  end
  
  test "should NOT create person" do
    assert_no_difference('Person.count') do
      post :create, :person => { }
    end
    assert_response :success
    assert_template 'new'
  end
  
  test "should_show_person" do
    get :show, :id => people(:josh).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_show_rp" do
    get :show, :id => people(:sue).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_get_edit" do
    get :edit, :id => 50000
    assert_response :success
  end
  
  test "should_show_only_campus_country_when_no_primary_involvement" do
    josh = Person.find 50000
    josh.current_address = nil
    josh.permanent_address = nil
    josh.primary_campus_involvement = nil
    josh.save!
    get :edit, :id => 50000
    assert_response :success
    assert_nil assigns['campus_country']
    assert_nil assigns['campus_state']
    assert_equal assigns['campuses'], []
    assert @response.body =~ /Choose a country/
  end
  
  test "should_show_possible_responsible_people" do
    if Cmt::CONFIG[:rp_system_enabled]
      get :edit, :id => 2000
      assert_response :success
      assert_not_nil assigns(:possible_responsible_people)
    else
      assert true
    end
  end
  
  test "should update person" do
    xhr :put, :update, :id => 50000, :person => {:first_name => 'josh', :last_name => 'starcher' }, 
                       :current_address => {:email => "josh.starcher@uscm.org"}, 
                       :perm_address => {:phone => '555-555-5555', :address1 => 'here'},
                       :primary_campus_id => 1, :primary_campus_involvement => {},
                       :responsible_person_id => people(:fred).id
    assert_template '_view'
  end
  
  test "should NOT update person" do
    xhr :put, :update, :id => 50000, :person => {:first_name => '' }
    assert_response :success
    assert_template '_edit'
  end
  
  test "should end a person's involvements" do
    @request.env["HTTP_REFERER"] = directory_people_path
    delete :destroy, :id => people(:sue).id
    assert person = assigns(:person)
    assert(!person.ministry_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a ministry involvement without an end date")
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "should end a person's campus involvements with no ministry involvements" do
    @request.env["HTTP_REFERER"] = directory_people_path
    delete :destroy, :id => people(:person_1).id
    assert person = assigns(:person)
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "change ministry and goto directory" do
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => '1'
    assert_response :success
  end
  
  test "change to a ministry that is under my assigned level" do
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => ministries(:dg).id
    assert_response :success
    assert_equal(3, session[:ministry_id])
    
    get :directory
    assert_equal(ministries(:dg), assigns(:ministry))
  end
  
  test "change to a ministry that is NOT under my assigned level should default to my first ministry" do
    get :change_ministry_and_goto_directory, :current_ministry => ministries(:top).id
    assert_response :redirect
    assert_not_equal(ministries(:top), assigns(:ministry))
    assert_equal(people(:josh).ministries.first, assigns(:ministry))
  end
  
  test "new person with no ministry involvements should be involved in the dummy ministry" do
    user = users(:user_with_no_ministry_involvements)
    @request.session[:user] = user.id
    @request.session[:ministry_id] = nil
  
    person = people(:person_with_no_ministry_involvements)
  
    get :directory, :person_id => person.id
  
    # person should be involved in 'No Ministry' ministry
    ministry = ministries(:no_ministry)
    ministry_involvements = MinistryInvolvement.find_all_by_person_id(person.id)
    assert ministry_involvements.any?{ |mr| mr.ministry_id == ministry.id }
    # assert_redirected_to :action => "index", :controller => "dashboard"
    assert_response :success, @response.body
  end
  
  test "ministry leader with no permanent address should render when updating notes" do
  
    # setup session
    ministry = ministries(:yfc)    
    
    user = users(:ministry_leader_user_with_no_permanent_address)
    @request.session[:user] = user.id
    @request.session[:ministry_id] = ministry.id
    
    person = people(:ministry_leader_person_with_no_permanent_address)
  
    # make sure person is a leader
    involvement = person.ministry_involvements.detect {|mi| mi.ministry_id == ministry.id}
    assert ministry.staff.include?(person) || (involvement && involvement.admin?)
    
    # make sure it renders properly
    get :show, :id => person.id
    
    assert_template :partial => '_view', :count => 1
    assert_response :success
  
    # save the staff notes    
    xhr :post, :update,
      :staff_notes => 'A Note',
      :id => person.id
    
    # make sure everything renders properly
    assert_response :success
    assert_template :partial => '_view', :count => 1    
  end
end
