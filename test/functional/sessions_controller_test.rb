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
  
  test 'went to CAS with bad credentials' do
    get :new, :errorKey => 'BadPassword'
    assert_response :success
  end
  
  test 'log in with local user' do
    post :create, :username => 'josh.starcher@example.com', :password => 'test', :remember_me => 1, :format => 'html'
    assert_response :redirect
    assert_redirected_to person_path(User.find(1).person)
  end
  
  test 'log in with bad username' do
    post :create, :username => 'josh.bad@example.com', :password => 'test', :remember_me => 1, :format => 'html'
   assert_response :success, @response.body
   assert_template 'new'
  end
  
  test 'log in with missing param' do
    post :create, :username => 'josh.bad@example.com', :password => '', :remember_me => 1, :format => 'html'
    assert_response :success, @response.body
    assert_template 'new'
  end
  
  test 'log in with gcx account' do
    post :create, :username => 'machomagna@gmail.com', :password => 'Abcd1234', :remember_me => 1
    assert_response :redirect
    assert_redirected_to 'https://signin.mygcx.org/cas/login?service=http://test.host/session/new&username=machomagna@gmail.com&password=Abcd1234'
  end
  
  test 'log out' do
    login
    delete :destroy
    assert_response :redirect
  end
end
