require File.dirname(__FILE__) + '/../test_helper'
require 'user_groups_controller'

# Re-raise errors caught by the controller.
class UserGroupsController; def rescue_action(e) raise e end; end

class UserGroupsControllerTest < Test::Unit::TestCase
  fixtures UserGroup.table_name

  def setup
    @controller = UserGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_new
    xhr :get, :new
    assert_response :success
  end

  def test_create
    count = UserGroup.count
    xhr :post, :create, :user_group => {:name => 'test'}
    assert_response :success
    assert_equal UserGroup.count, count+1
  end
  
  def test_create_bad
    count = UserGroup.count
    xhr :post, :create, :user_group => {:name => ''}
    assert_response :success
    assert_equal UserGroup.count, count
  end

  def test_edit
    xhr :get, :edit, :id => 1
    assert_response :success
  end

  def test_destroy
    count = UserGroup.count
    xhr :delete, :destroy, :id => 1
    assert_response :success
    assert_equal(count-1, UserGroup.count)
  end
end
