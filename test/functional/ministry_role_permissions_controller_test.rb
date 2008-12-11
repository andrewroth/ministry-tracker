require File.dirname(__FILE__) + '/../test_helper'

class MinistryRolePermissionsControllerTest < ActionController::TestCase
  fixtures MinistryRolePermission.table_name
  def setup
    login
  end

  test "should create ministry_role_permission" do
    assert_difference('MinistryRolePermission.count') do
      post :create, :ministry_role_permission => {:ministry_role_id => 1, :permission_id => 1 }
      assert mrp = assigns(:ministry_role_permission)
      assert_equal([], mrp.errors.full_messages)
    end
    assert_response :success, @response.body
  end

  test "should destroy ministry_role_permission" do
    assert_difference('MinistryRolePermission.count', -1) do
      delete :destroy, :id =>1
    end

    assert_response :success, @response.body
  end
end
