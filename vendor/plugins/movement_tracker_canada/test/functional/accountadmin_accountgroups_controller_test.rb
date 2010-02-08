require 'test_helper'

class AccountadminAccountgroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountadmin_accountgroups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountadmin_accountgroup" do
    assert_difference('AccountadminAccountgroup.count') do
      post :create, :accountadmin_accountgroup => { }
    end

    assert_redirected_to accountadmin_accountgroup_path(assigns(:accountadmin_accountgroup))
  end

  test "should show accountadmin_accountgroup" do
    get :show, :id => accountadmin_accountgroups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accountadmin_accountgroups(:one).to_param
    assert_response :success
  end

  test "should update accountadmin_accountgroup" do
    put :update, :id => accountadmin_accountgroups(:one).to_param, :accountadmin_accountgroup => { }
    assert_redirected_to accountadmin_accountgroup_path(assigns(:accountadmin_accountgroup))
  end

  test "should destroy accountadmin_accountgroup" do
    assert_difference('AccountadminAccountgroup.count', -1) do
      delete :destroy, :id => accountadmin_accountgroups(:one).to_param
    end

    assert_redirected_to accountadmin_accountgroups_path
  end
end
