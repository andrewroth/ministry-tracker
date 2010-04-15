require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "new" do
    get :new
    assert_response :success
  end
  
  test 'new but already logged in' do
    setup_default_user
    login
    get :new
    assert_response :redirect
  end
  
  test 'went to CAS with bad credentials' do
    get :new, :errorKey => 'BadPassword'
    assert_response :success
  end
  
  test 'log in with local user' do
    setup_default_user
    post :create, :username => 'josh.starcher@example.com', :password => 'test', :remember_me => 1, :format => 'html'
    if !Cmt::CONFIG[:local_direct_logins] && !Cmt::CONFIG[:local_direct_logins] && !Cmt::CONFIG[:gcx_direct_logins]
      assert_response :success, @response.body
      assert_template 'new'
    else
      assert_response :redirect
      assert_redirected_to '/'
    end
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
  
  test 'log out' do
    setup_default_user
    login
    delete :destroy
    assert_response :redirect
  end
end
