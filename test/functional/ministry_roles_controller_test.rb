require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_roles_controller'

# Re-raise errors caught by the controller.
class MinistryRolesController; def rescue_action(e) raise e end; end

class MinistryRolesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_ministry_roles
    @controller = MinistryRolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_show
    get :show, :person_id => '50000', :ministry_id => 1
    assert_response :success
    assert_equal(1, assigns["ministry_role"].id)

    get :show, :guid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026', :ministry_id => 1
    assert_response :success
    assert_equal(1, assigns["ministry_role"].id)
  end

  def test_index
    get :index
    assert_response :success, @response.body
  end

  def test_new
    xhr :get, :new
    assert_response :success, @response.body
  end

  def test_edit
    xhr :get, :edit, :id => 1
    assert_response :success, @response.body
  end

  def test_create_good
    assert_difference("MinistryRole.count") do
      xhr :post, :create, :ministry_role => {:type => 'StaffRole', :name => 'Admin'}
    end
    assert_response :success, @response.body
  end
  
  # this checks to see if, when you create a new ministry_role when @ministry = 2, 
  # that your ministry_role.ministry_id is the root of that ministry
  def test_create_different_ministry_id
    ministry = Factory(:ministry_2)
    session[:ministry_id] = ministry.id
    assert_difference("MinistryRole.count") do
      xhr :post, :create, :ministry_role => {:type => 'StaffRole', :name => 'Admin'}
      assert ministry_role = assigns(:ministry_role)
      assert_equal([], ministry_role.errors.full_messages)
      assert_response :success, @response.body
      # asserts that we are infact looking at another ministry
      assert_equal ministry.id, assigns(:ministry).id
      # asserts this ministry_role was assigned to our current ministry
      assert_equal ministry.root.id, MinistryRole.find(:last).ministry_id
    end
  end

  
  
  def test_create_bad
    assert_no_difference("MinistryRole.count") do
      xhr :post, :create, :ministry_role => {:type => 'StaffRole', :name => ''}
    end
    assert_response :success, @response.body
  end

  def test_update_good
    xhr :put, :update, :ministry_role => {:name => 'Admin'}, :id => 1
    assert mr = assigns(:ministry_role)
    assert_equal([], mr.errors.full_messages)
    assert_response :success, @response.body
  end

  def test_update_bad
    xhr :put, :update, :ministry_role => {:name => ''}, :id => 1
    assert mr = assigns(:ministry_role)
    assert_equal(["Name can't be blank"], mr.errors.full_messages)
    assert_response :success, @response.body
  end
  
  def test_destroy
    assert_difference("MinistryRole.count", -1) do
      xhr :delete, :destroy, :id => 2
    end
  end
  
  def test_cant_destroy_non_empty_role
    assert_no_difference("MinistryRole.count") do
      xhr :delete, :destroy, :id => 1
    end
  end
  
  def test_permissions
    xhr :get, :permissions, :id => 1
    assert_response :success, @response.body
  end
  
  def test_reorder_staff_list
    xhr :post, :reorder, :staff_role_list => ["1", "2"]
    assert_response :success, @response.body
  end
  
  def test_reorder_student_list
    xhr :post, :reorder, :student_role_list => ["4", "5"]
    assert_response :success, @response.body
  end
  
  def test_reorder_other_list
    xhr :post, :reorder, :other_role_list => ["6"]
    assert_response :success, @response.body
  end
  
end
