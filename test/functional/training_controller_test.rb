require File.dirname(__FILE__) + '/../test_helper'
require 'training_controller'

# Re-raise errors caught by the controller.
class TrainingController; def rescue_action(e) raise e end; end

class TrainingControllerTest < ActionController::TestCase
  fixtures TrainingCategory.table_name

  def setup
    @controller = TrainingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:training_categories)
  end
end
