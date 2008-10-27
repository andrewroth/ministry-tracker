require File.dirname(__FILE__) + '/../test_helper'

class CustomizeControllerTest < ActionController::TestCase
  fixtures TrainingCategory.table_name
  def setup
    login
  end
  
  def test_show
    get :show
    assert_response :success
  end
  
  def test_reorder_training_categories
    post :reorder_training_categories, :id => 1, 'training_categories_list' => ['1']
    assert_response :success
  end
end
