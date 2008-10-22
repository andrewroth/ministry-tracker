require File.dirname(__FILE__) + '/../test_helper'
require 'auth_controller'

# Re-raise errors caught by the controller.
class AuthController; def rescue_action(e) raise e end; end

class AuthControllerTest < Test::Unit::TestCase
  fixtures Person.table_name, User.table_name
  def setup
    @controller = AuthController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login
    login
    get :perform_login
    assert_response :redirect
  end
  
  # def test_perform_login
  #   post :perform_login, :username => "josh.starcher", :password => "test"
  #   assert_response :redirect
  #   assert_redirected_to person_url(people(:josh).id)
  # end
  # 
  # def test_perform_login_failure
  #   post :perform_login
  #   assert_response :redirect
  #   assert_redirected_to :action => :login
  # end
  
  def test_logout
    login
    get :logout
    assert_response :redirect
  end
end
