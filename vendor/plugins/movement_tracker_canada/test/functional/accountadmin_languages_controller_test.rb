require 'test_helper'

class AccountadminLanguagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountadmin_languages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountadmin_language" do
    assert_difference('AccountadminLanguage.count') do
      post :create, :accountadmin_language => { }
    end

    assert_redirected_to accountadmin_language_path(assigns(:accountadmin_language))
  end

  test "should show accountadmin_language" do
    get :show, :id => accountadmin_languages(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => accountadmin_languages(:one).to_param
    assert_response :success
  end

  test "should update accountadmin_language" do
    put :update, :id => accountadmin_languages(:one).to_param, :accountadmin_language => { }
    assert_redirected_to accountadmin_language_path(assigns(:accountadmin_language))
  end

  test "should destroy accountadmin_language" do
    assert_difference('AccountadminLanguage.count', -1) do
      delete :destroy, :id => accountadmin_languages(:one).to_param
    end

    assert_redirected_to accountadmin_languages_path
  end
end
