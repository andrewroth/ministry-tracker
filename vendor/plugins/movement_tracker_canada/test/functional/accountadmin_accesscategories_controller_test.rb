require 'test_helper'

class AccountadminAccesscategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountadmin_accesscategories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountadmin_accesscategory" do
    assert_difference('AccountadminAccesscategory.count') do
      post :create, :accountadmin_accesscategory => { }
    end

    assert_redirected_to accountadmin_accesscategory_path(assigns(:accountadmin_accesscategory))
  end

  test "should show accountadmin_accesscategory" do
    get :show, :id => accountadmin_accesscategories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accountadmin_accesscategories(:one).to_param
    assert_response :success
  end

  test "should update accountadmin_accesscategory" do
    put :update, :id => accountadmin_accesscategories(:one).to_param, :accountadmin_accesscategory => { }
    assert_redirected_to accountadmin_accesscategory_path(assigns(:accountadmin_accesscategory))
  end

  test "should destroy accountadmin_accesscategory" do
    assert_difference('AccountadminAccesscategory.count', -1) do
      delete :destroy, :id => accountadmin_accesscategories(:one).to_param
    end

    assert_redirected_to accountadmin_accesscategories_path
  end
end
