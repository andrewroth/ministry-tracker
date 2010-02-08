require 'test_helper'

class AccountadminAccountadminaccessesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountadmin_accountadminaccesses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountadmin_accountadminaccess" do
    assert_difference('AccountadminAccountadminaccess.count') do
      post :create, :accountadmin_accountadminaccess => { }
    end

    assert_redirected_to accountadmin_accountadminaccess_path(assigns(:accountadmin_accountadminaccess))
  end

  test "should show accountadmin_accountadminaccess" do
    get :show, :id => accountadmin_accountadminaccesses(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accountadmin_accountadminaccesses(:one).to_param
    assert_response :success
  end

  test "should update accountadmin_accountadminaccess" do
    put :update, :id => accountadmin_accountadminaccesses(:one).to_param, :accountadmin_accountadminaccess => { }
    assert_redirected_to accountadmin_accountadminaccess_path(assigns(:accountadmin_accountadminaccess))
  end

  test "should destroy accountadmin_accountadminaccess" do
    assert_difference('AccountadminAccountadminaccess.count', -1) do
      delete :destroy, :id => accountadmin_accountadminaccesses(:one).to_param
    end

    assert_redirected_to accountadmin_accountadminaccesses_path
  end
end
