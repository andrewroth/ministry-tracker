require File.dirname(__FILE__) + '/../test_helper'
require 'user_group_permissions_controller'

# Re-raise errors caught by the controller.
class UserGroupPermissionsController; def rescue_action(e) raise e end; end

class UserGroupPermissionsControllerTest < Test::Unit::TestCase
  fixtures UserGroupPermission.table_name, UserGroup.table_name, Permission.table_name

  def setup
    @controller = UserGroupPermissionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    xhr :get, :index
    assert_response :success
  end

  # def test_create
  #   count = UserGroupPermission.count
  #   xhr :post, :create, :user_group_id => 1, :permissions => ['1']
  #   assert_response :success
  #   assert_equal UserGroupPermission.count, count+1
  # end
  # 
  # def test_destroy
  #   count = UserGroupPermission.count
  #   xhr :delete, :destroy, :user_group_permissions => ['1'], :user_group_id => 1
  #   assert_response :success
  #   assert_equal UserGroupPermission.count, count-1
  # end
end
