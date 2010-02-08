require 'test_helper'

class AccountadminAccessgroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountadmin_accessgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountadmin_accessgroup" do
    assert_difference('AccountadminAccessgroup.count') do
      post :create, :accountadmin_accessgroup => { }
    end

    assert_redirected_to accountadmin_accessgroup_path(assigns(:accountadmin_accessgroup))
  end

  test "should show accountadmin_accessgroup" do
    get :show, :id => accountadmin_accessgroups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accountadmin_accessgroups(:one).to_param
    assert_response :success
  end

  test "should update accountadmin_accessgroup" do
    put :update, :id => accountadmin_accessgroups(:one).to_param, :accountadmin_accessgroup => { }
    assert_redirected_to accountadmin_accessgroup_path(assigns(:accountadmin_accessgroup))
  end

  test "should destroy accountadmin_accessgroup" do
    assert_difference('AccountadminAccessgroup.count', -1) do
      delete :destroy, :id => accountadmin_accessgroups(:one).to_param
    end

    assert_redirected_to accountadmin_accessgroups_path
  end
end
