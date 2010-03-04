require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'


# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    setup_ministry_roles
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
  
  test "when i do a search, save it" do
    assert_difference "Search.count" do
      post :directory, :search => 'all'
    end
  end
  
  test "directory pagination" do
    post :directory, :search => 'all'
    assert_response :success
    assert assigns(:people)
  end
  
  test "A user should be able to see a directory a directory on a ministry with no campuses" do
    Factory(:user_6)
    Factory(:person_7)
    Factory(:ministryinvolvement_6)
    Factory(:ministry_4)

    login('staff_on_ministry_with_no_campus')
    @request.session[:ministry_id] = Factory(:ministry_5).id #under_top is under top, which I am a member of
    get :directory
    assert_response :success
    assert assigns(:people)
  end
  
  test "A person with no campus involvements should still show in the directory" do
    Factory(:user_6)
    Factory(:person_7)
    Factory(:ministryinvolvement_6)
    Factory(:ministry_4)

    login('staff_on_ministry_with_no_campus')
    session[:ministry_id] = Factory(:ministry_4).id
    get :directory
    assert_response :success, @response.body
    assert(ppl = assigns(:people), "@people wasn't assigned")
    assert(ppl.detect {|p| p['person_id'].to_i == Factory(:person_7).id}, "staff_on_ministry_with_no_campus didn't show up.")
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
  
  test "should restrict students directory to their campuses" do
    Factory(:user_3)
    Factory(:person_3)
    Factory(:ministryinvolvement_4)
    Factory(:campus_1)
    Factory(:campus_2)
    Factory(:campusinvolvement_2)
    Factory(:campusinvolvement_4)
    
    login 'sue@student.org'
    get :directory
    assert_equal @person.campuses, assigns(:campuses)
  end
 
  test "should have all campuses on directory for staff" do
    get :directory
    assert_equal Ministry.first.campuses + Ministry.first.children.collect(&:campuses).flatten, assigns(:campuses)
  end

  test "should clear session order when changing view" do
    get :directory, :order => Person._(:first_name)
    post :change_view, :view => '1'
    assert_redirected_to directory_people_path(:format => :html)
    assert_nil session[:order]
  end
  
  test "should re-create staff" do
    Factory(:address_1)
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
    Factory(:address_1)
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
    get :show, :id => Factory(:person_1).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_show_rp" do
    get :show, :id => Factory(:person_3).id
    
    assert_template :show
    assert_template :partial => '_view', :count => 1
    assert_response :success
  end
  
  test "should_get_edit" do
    get :edit, :id => 50000
    assert_response :success
  end
  
  test "should_get_edit_for_someone_in_my_group" do
    Factory(:user_3)
    Factory(:person_3)
    Factory(:ministryinvolvement_4)
    Factory(:ministry_1)
    Factory(:campus_1)
    Factory(:campus_2)
    Factory(:campusinvolvement_2)
    Factory(:campusinvolvement_4)
    setup_groups
    login('sue@student.org') # leading group 3; sue is a student ministry leader
    get :edit, :id => 50 # member in group 3
    assert_response :success
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
    Factory(:person_2)
    xhr :put, :update, :id => 50000, :person => {:first_name => 'josh', :last_name => 'starcher' }, 
                       :current_address => {:email => "josh.starcher@uscm.org"}, 
                       :perm_address => {:phone => '555-555-5555', :address1 => 'here'},
                       :primary_campus_id => 1, :primary_campus_involvement => {},
                       :responsible_person_id => Factory(:person_2).id
    assert_template '_view'
  end
  
  test "should NOT update person" do
    xhr :put, :update, :id => 50000, :person => {:first_name => '' }
    assert_response :success
    assert_template '_edit'
  end
  
  test "should end a person's involvements" do
    @request.env["HTTP_REFERER"] = directory_people_path
    delete :destroy, :id => Factory(:person_3).id
    assert person = assigns(:person)
    assert(!person.ministry_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a ministry involvement without an end date")
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "should end a person's campus involvements with no ministry involvements" do
    @request.env["HTTP_REFERER"] = directory_people_path
    reset_people_sequences
    Factory(:person)
    delete :destroy, :id => 1
    assert person = assigns(:person)
    assert(!person.campus_involvements.reload.collect(&:end_date).collect(&:nil?).include?(true), "There's a campus involvement without an end date")
    assert_redirected_to directory_people_path
  end
  
  test "change ministry and goto directory" do
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => '1'
    assert_response :success
  end
  
  test "change to a ministry that is under my assigned level" do
    xhr :post, :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_3).id
    assert_response :success
    assert_equal(3, session[:ministry_id])
    
    get :directory
    assert_equal(Factory(:ministry_3), assigns(:ministry))
  end
  
  test "change to a ministry that is NOT under my assigned level should default to my first ministry for student" do
    Factory(:user_5)
    Factory(:person_6)
    Factory(:ministryinvolvement_5)
    Factory(:ministry_5)
    Factory(:campusinvolvement_5)
    Factory(:campus_1)
    login 'min_leader_with_no_permanent_address'
    get :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_4).id
    assert_response :redirect
    assert_not_equal(Factory(:ministry_4), assigns(:ministry))
    assert_equal(Factory(:person_6).ministries.first, assigns(:ministry))
  end

  test "change to a ministry that is NOT under my assigned level should still work for staff" do
    get :change_ministry_and_goto_directory, :current_ministry => Factory(:ministry_4).id
    assert_response :redirect
    assert_equal(Factory(:ministry_4), assigns(:ministry))
  end
 
  
  test "user with no ministry involvements should be redirected to set their initial campus" do
    Factory(:user_4)
    Factory(:person_5)
    login('user_with_no_ministry_involvements')
  
    get :directory
  
    assert_redirected_to "http://test.host/people/4000/set_initial_campus"
  end
  
  test "ministry leader with no permanent address should render when updating notes" do
  
    # setup session
    ministry = Factory(:ministry_5)
    
    user = Factory(:user_5)
    @request.session[:user] = user.id
    @request.session[:ministry_id] = ministry.id
    
    person = Factory(:person_6)
    Factory(:ministryinvolvement_5)
    Factory(:campusinvolvement_5)
    Factory(:campus_1)
    Factory(:ministry_4)
  
    # make sure it renders properly
    get :show, :id => person.id
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
