require File.dirname(__FILE__) + '/../test_helper'
require 'developers_controller'

# Re-raise errors caught by the controller.
class DevelopersController; def rescue_action(e) raise e end; end

class DevelopersControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    @controller = DevelopersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_create_good_email
    post :create, :email => 'josh.starcher@example.com'
    assert_response :success
  end
  
  def test_create_bad_email
    post :create, :email => 'josh.starcher@uscm.org'
    assert_response :success
  end

  def test_destroy
    delete :destroy, :id => 1
    assert_response :success
  end
end
