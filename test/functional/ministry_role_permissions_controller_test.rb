require File.dirname(__FILE__) + '/../test_helper'

class MinistryRolePermissionsControllerTest < ActionController::TestCase
  def setup
    setup_default_user
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

  test "should NOT create ministry_role_permission" do
    assert_no_difference('MinistryRolePermission.count') do
      xhr :post, :create, :ministry_role_permission => {:ministry_role_id => '', :permission_id => 1 }
    end
    assert mrp = assigns(:ministry_role_permission)
    assert_equal(["Ministry role can't be blank"], mrp.errors.full_messages)
    assert_response :success, @response.body
  end

  test "should destroy ministry_role_permission" do
    Factory(:ministryrolepermission_1)
    assert_difference('MinistryRolePermission.count', -1) do
      delete :destroy, :id =>1
    end

    assert_response :success, @response.body
  end
end
