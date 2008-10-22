require File.dirname(__FILE__) + '/../test_helper'
require 'students_controller'

# Re-raise errors caught by the controller.
class StudentsController; def rescue_action(e) raise e end; end

class StudentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = StudentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
  end
end
