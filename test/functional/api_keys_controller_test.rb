require File.dirname(__FILE__) + '/../test_helper'

class ApiKeysControllerTest < ActionController::TestCase
  
  def setup
    setup_default_user
    setup_ministry_roles
    setup_api_keys

    login
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_keys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_key" do
    assert_difference('ApiKey.count') do
      post :create, :api_key => {:user_id => "1", :purpose => "automated tests"}
    end

    assert_redirected_to api_key_path(assigns(:api_key))
    assert_not_nil assigns(:api_key).login_code_id
    assert_not_nil assigns(:api_key).login_code
  end

  test "should show api_key" do
    get :show, :id => Factory(:api_key_1).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => Factory(:api_key_1).id
    assert_response :success
  end

  test "should update api_key" do
    put :update, :id => Factory(:api_key_1).id, :api_key => {:purpose => "test updating api key", :user_id => "1"}
    assert_redirected_to api_key_path(assigns(:api_key))
  end

  test "should destroy api_key" do
    assert_difference('ApiKey.count', -1) do
      delete :destroy, :id => Factory(:api_key_1).id
    end

    assert_redirected_to api_keys_path
  end
end
