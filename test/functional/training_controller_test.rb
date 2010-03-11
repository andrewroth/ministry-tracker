require File.dirname(__FILE__) + '/../test_helper'

class TrainingControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    
    login
  end
  
  def test_should_get_index
    get :index
    assert_response :success
  end
end
