require File.dirname(__FILE__) + '/../test_helper'

class CustomizeControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    login
  end
  
  def test_show
    get :show
    assert_response :success
  end
  
  def test_reorder_training_categories
    post :reorder_training_categories, :id => 1, 'training_categories_list' => ['2','1']
    assert_response :success
  end
end
