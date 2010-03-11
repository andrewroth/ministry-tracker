require File.dirname(__FILE__) + '/../test_helper'
require 'permissions_controller'

# Re-raise errors caught by the controller.
class PermissionsController; def rescue_action(e) raise e end; end

class PermissionsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:permission_1)
    Factory(:permission_2)

    @controller = PermissionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    get :index
    assert_response :success
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
    assert_difference("Permission.count") do
      xhr :post, :create, :permission => {:description => 'Test Perm', :controller => 'foo', :action => 'bar'}
    end
    assert_response :success, @response.body
  end

  def test_create_bad
    assert_no_difference("Permission.count") do
      xhr :post, :create, :permission => {:description => ''}
    end
    assert_response :success, @response.body
  end

  def test_update_good
    xhr :put, :update, :permission => {:description => 'Admin'}, :id => 1
    assert mr = assigns(:permission)
    assert_equal([], mr.errors.full_messages)
    assert_response :success, @response.body
  end

  def test_update_bad
    xhr :put, :update, :permission => {:description => ''}, :id => 1
    assert mr = assigns(:permission)
    assert_equal(["Description can't be blank"], mr.errors.full_messages)
    assert_response :success, @response.body
  end
  
  def test_destroy
    assert_difference("Permission.count", -1) do
      xhr :delete, :destroy, :id => 2
    end
  end

end
