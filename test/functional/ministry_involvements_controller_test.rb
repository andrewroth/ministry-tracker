require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_involvements_controller'

# Re-raise errors caught by the controller.
class MinistryInvolvementsController; def rescue_action(e) raise e end; end

class MinistryInvolvementsControllerTest < ActionController::TestCase

  def setup
    setup_ministry_roles
    setup_default_user
    setup_years
    setup_months
    
    @controller = MinistryInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  test "destroy" do
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert_equal Date.today, MinistryInvolvement.find(1).end_date
    assert assigns(:ministry_involvement)
    assert_response :success
  end

  test "try destroying default ministry" do
  	Factory(:person_6)
    Factory(:person_2)
    Factory(:user_2)
    Factory(:access_2)

    login 'fred@uscm.org'

    mi = Factory(:ministryinvolvement_7)
    Cmt::CONFIG[:default_ministry_name] = mi.ministry.name
    xhr :delete, :destroy, :id => 7, :person_id => 3000
  end

  test "try destroying without access" do
  	Factory(:person_6)
    Factory(:person_2)
    Factory(:access_2)
    Factory(:user_2)
    login('fred@uscm.org')
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert_equal nil, MinistryInvolvement.find(1).end_date
    assert_equal nil, assigns(:ministry_involvement)
    assert_response :redirect
  end

  # test "destroy only one ministry" do
  #   xhr :delete, :destroy, :id => 1, :person_id => 3000
  #   assert_nil assigns(:ministry_involvement)
  #   assert_response :success
  # end

  test "edit own role" do
    xhr :get, :edit, :person_id => 50000, :ministry_id => 2
    assert_response :success
    assert_template 'edit'
  end

  test "edit someone else's role" do
  	Factory(:person_6)
    Factory(:person_2)
    xhr :get, :edit, :person_id => 3000, :ministry_id => 2
    assert_response :success
    assert assigns(@ministry_involvement)
  end

  test "edit with bad parameters" do
    assert_raise(RuntimeError) { xhr :get, :edit }
  end

  test "update role" do
    old_mi = MinistryInvolvement.find(1)
    old_mi_ministry_role_id = old_mi.ministry_role_id
    xhr :put, :update, :id => old_mi.id, :ministry_involvement => {:ministry_role_id => 4}
    assert mi = assigns(:ministry_involvement)
    assert_not_equal old_mi_ministry_role_id, mi.ministry_role_id
  end

  test "add a person to a ministry" do
    assert_difference "MinistryInvolvement.count", 1 do
      ministry = Factory(:ministry_3)
      person = Factory(:person_1)
      xhr :post, :create, :ministry_involvement => {:ministry_role_id => ministry.ministry_roles.first, :person_id => person.id, :ministry_id => ministry.id}
    end
  end

  test "add a person to a ministry who is already in that ministry should update the role" do
    assert_difference "MinistryInvolvement.count", 0 do
      ministry = Factory(:ministry_1)
      person = Factory(:person_1)
      old_role = Factory(:ministryinvolvement_1).ministry_role
      attribs = {:ministry_role_id => Factory(:ministryrole_2).id, :person_id => person.id, :ministry_id => ministry.id}
      xhr :post, :create, :ministry_involvement => attribs
      assert(@mi = assigns(:ministry_involvement))
      assert_not_equal(old_role, @mi.ministry_role)
    end
  end

  test "can edit a ministry_involvement" do # promoting
    Factory(:ministryinvolvement_1)
    mi = MinistryInvolvement.first
    get :edit, :ministry_id => mi.ministry.id, :person_id => mi.person.id
    assert_response :success
  end

  test "edit handles invalid parameters without crashing" do
    123.times{ Factory(:person) }
    @request.env["HTTP_REFERER"] = 'test.com'
    get :edit, :ministry_id => Ministry.first.id, :person_id => Person.find(123)
    assert_response :redirect
  end

  def test_index
    xhr :get, :index
    assert_not_nil(assigns["ministry_involvements"])
    assert_not_nil(assigns["involvement_history"])
  end

  def test_new
    xhr :get, :new
    assert_not_nil(assigns["ministry_involvement"])
  end
  


  test "edit multiple roles" do
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:ministryinvolvement_12)
    Factory(:ministryinvolvement_13)
    Factory(:person_6)
    Factory(:person_2)
    Factory(:person_8)

    get :edit_multiple_roles, :person => ["4001", "4003", "3000"], :mids => ["7"]
 
    assert assigns(:involvements)
    assert_equal 2, assigns(:involvements).size

    assert assigns(:people_without_involvements)
    assert_equal 1, assigns(:people_without_involvements).size
  end

  test "edit multiple roles with role search" do
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:ministryinvolvement_12)
    Factory(:ministryinvolvement_13)
    Factory(:person_6)
    Factory(:person_2)
    Factory(:person_8)

    get :edit_multiple_roles, :person => ["4001", "4003", "3000"], :mids => ["7"], :mrids => ["7"]

    assert assigns(:involvements)
    assert_equal 1, assigns(:involvements).size

    assert assigns(:people_without_involvements)
    assert_equal 2, assigns(:people_without_involvements).size
  end

  test "update multiple roles" do
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:person_6)
    Factory(:person_2)
    Factory(:person_8)

    put :update_multiple_roles, :involvement_id => ["5","8"], :role => {:id => "5"}

    assert_equal 5, MinistryInvolvement.find(5).ministry_role_id
    assert_equal 5, MinistryInvolvement.find(8).ministry_role_id
  end

  test "update multiple roles no permission" do
    setup_people
    setup_ministry_involvements
    Factory(:permission_13)
    Factory(:ministryrolepermission_20)
    Factory(:ministryrolepermission_21)
    Factory(:user_2)
    Factory(:person_6)
    Factory(:person_2)
    Factory(:access_2)
    login "fred@uscm.org"
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:person_6)
    Factory(:person_2)
    Factory(:person_8)

    put :update_multiple_roles, :involvement_id => ["5","8"], :role => {:id => "5"}

    assert_equal 4, MinistryInvolvement.find(5).ministry_role_id
    assert_equal 5, MinistryInvolvement.find(8).ministry_role_id
  end

  test "update multiple roles promote student to staff" do
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:ministryrole_10)
    Factory(:person_6)
    Factory(:person_8)

    put :update_multiple_roles, :involvement_id => ["8"], :role => {:id => "10"}

    assert_equal 10, MinistryInvolvement.find(8).ministry_role_id
  end

  test "update multiple roles demote staff to student" do
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_6)
    Factory(:person_7)

    put :update_multiple_roles, :involvement_id => ["6"], :role => {:id => "7"}

    assert_equal 7, MinistryInvolvement.find(6).ministry_role_id
  end
  
  test "remove involvements for multiple people" do  
    @today = Date.today     #.strftime("%Y-%m-%d") 
    setup_people
    setup_ministry_involvements
    setup_ministries
    Factory(:ministryinvolvement_8)
    Factory(:campusinvolvement_8)   #1008, tied to mi 5
    Factory(:campusinvolvement_9)   #1009, tied to mi 8
    Factory(:groupinvolvement_11)   #11 tied to person 4001
    Factory(:groupinvolvement_12)   #12 tied to person 4001

    Factory(:person_6)    
    Factory(:person_2)
    Factory(:person_8)

    put :update_multiple_roles, :involvement_id => ["5","8"], :role => {:id => "-1"}
    
    assert_equal @today, MinistryInvolvement.find(5).end_date
    assert_equal @today, MinistryInvolvement.find(8).end_date
   
    assert_equal @today, CampusInvolvement.find(Factory(:campusinvolvement_8).id).end_date
    assert_equal @today, CampusInvolvement.find(Factory(:campusinvolvement_9).id).end_date
    
    record_not_found = false
    begin
      try_to_find_gi11 = GroupInvolvement.find(11)
    rescue ActiveRecord::RecordNotFound
      record_not_found = true
    end   
    assert_equal true, record_not_found
    
    record_not_found = false
    begin
      try_to_find_gi12 = GroupInvolvement.find(12)
    rescue ActiveRecord::RecordNotFound
      record_not_found = true
    end
    assert_equal true, record_not_found
    
  end
  
  
  test "remove involvements for multiple people no permission" do
    setup_people
    setup_ministry_involvements
    # setup permissions for roles other than that of the logged-in user
    Factory(:permission_14)
    Factory(:ministryrolepermission_22)
    Factory(:ministryrolepermission_23)
    
    Factory(:user_2)
    Factory(:person_6)     # add to setup mentorship for person #2
    Factory(:person_2)
    Factory(:access_2)
    login "fred@uscm.org"
    setup_ministries
    Factory(:ministryinvolvement_12)
    Factory(:campusinvolvement_8)   #1008, tied to mi 5
    Factory(:campusinvolvement_9)   #1009, tied to mi 8
    Factory(:groupinvolvement_11)   #11 tied to person 4001
    Factory(:groupinvolvement_12)   #12 tied to person 4001   
    Factory(:person_6) 
    Factory(:person_2)
    Factory(:person_8)

    put :update_multiple_roles, :involvement_id => ["5","12"], :role => {:id => "-1"}

    assert_equal 4, MinistryInvolvement.find(5).ministry_role_id
    assert_equal 7, MinistryInvolvement.find(12).ministry_role_id
    
    assert_nil MinistryInvolvement.find(5).end_date
    assert_nil MinistryInvolvement.find(12).end_date
   
    assert_nil CampusInvolvement.find(Factory(:campusinvolvement_8).id).end_date
    assert_nil CampusInvolvement.find(Factory(:campusinvolvement_9).id).end_date
   
    
    record_found = false
    begin
      try_to_find_gi11 = GroupInvolvement.find(11)
      assert_equal 11, GroupInvolvement.find(11).id
      record_found = true
    rescue ActiveRecord::RecordNotFound
      record_found = false
    end   
    assert_equal true, record_found
    
    record_found = false
    begin
      try_to_find_gi12 = GroupInvolvement.find(12)
      assert_equal 12, GroupInvolvement.find(12).id
      record_found = true
    rescue ActiveRecord::RecordNotFound
      record_found = false
    end   
    assert_equal true, record_found
  end
  
end
