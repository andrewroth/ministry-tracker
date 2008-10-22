require File.dirname(__FILE__) + '/../test_helper'
require 'staff_controller'

# Re-raise errors caught by the controller.
class StaffController; def rescue_action(e) raise e end; end

class StaffControllerTest < Test::Unit::TestCase
  fixtures Staff.table_name

  def setup
    @controller = StaffController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  
  
  def test_should_get_index
    get :index
    assert_response :success
  end
end
