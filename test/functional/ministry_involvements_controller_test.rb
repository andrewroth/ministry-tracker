require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_involvements_controller'

# Re-raise errors caught by the controller.
class MinistryInvolvementsController; def rescue_action(e) raise e end; end

class MinistryInvolvementsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_ministry_roles
    
    @controller = MinistryInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  test "destroy" do
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert assigns(:ministry_involvement)
    assert_response :success
  end

  test "try destroying default ministry" do
    Factory(:person_2)
    Factory(:user_2)
    login 'fred@uscm.org'

    mi = Factory(:ministryinvolvement_7)
    Cmt::CONFIG[:default_ministry_name] = mi.ministry.name
    xhr :delete, :destroy, :id => 7, :person_id => 3000
  end

  test "try destroying without access" do
    Factory(:user_2)
    login('fred@uscm.org')
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert_equal Date.today, assigns(:ministry_involvement).end_date
    assert_response :success
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
    xhr :put, :update, :id => old_mi.id, :ministry_involvement => {:ministry_role_id => 4}
    assert mi = assigns(:ministry_involvement)
    assert_not_equal old_mi.ministry_role, mi.ministry_role
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
end
