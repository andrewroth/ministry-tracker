require File.dirname(__FILE__) + '/../test_helper'
require 'manage_controller'

# Re-raise errors caught by the controller.
class ManageController; def rescue_action(e) raise e end; end

class ManageControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    @controller = ManageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    get :index
    assert_response :success
  end
end
