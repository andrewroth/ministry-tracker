require File.dirname(__FILE__) + '/../test_helper'
require 'dashboard_controller'

# Re-raise errors caught by the controller.
class DashboardController; def rescue_action(e) raise e end; end

class DashboardControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    @controller = DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_flash_helper
    setup_years
    setup_months
    get :index
    assert_response :success
  end

  def test_events
    get :events

    assert_not_nil assigns(:my_campuses)
    assert_response :success

  end
end
