require File.dirname(__FILE__) + '/../test_helper'

class MinistryRolePermissionsControllerTest < ActionController::TestCase
  fixtures MinistryRolePermission.table_name
  def setup
    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ministry_role_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ministry_role_permission" do
    assert_difference('MinistryRolePermission.count') do
      post :create, :ministry_role_permission => { }
    end

    assert_redirected_to ministry_role_permission_path(assigns(:ministry_role_permission))
  end

  test "should show ministry_role_permission" do
    get :show, :id => 1
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => 1
    assert_response :success
  end

  test "should update ministry_role_permission" do
    put :update, :id =>1, :ministry_role_permission => { }
    assert_redirected_to ministry_role_permission_path(assigns(:ministry_role_permission))
  end

  test "should destroy ministry_role_permission" do
    assert_difference('MinistryRolePermission.count', -1) do
      delete :destroy, :id =>1
    end

    assert_redirected_to ministry_role_permissions_path
  end
end
