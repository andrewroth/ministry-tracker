require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "new" do
    get :new
    assert_response :success
  end
  
  test 'new but already logged in' do
    login
    get :new
    assert_response :redirect
  end
  
  test 'log out' do
    login
    delete :destroy
    assert_response :redirect
  end
end
