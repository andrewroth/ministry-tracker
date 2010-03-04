require File.dirname(__FILE__) + '/../test_helper'
require 'training_categories_controller'

# Re-raise errors caught by the controller.
class TrainingCategoriesController; def rescue_action(e) raise e end; end

class TrainingCategoriesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:trainingcategory_1)
    Factory(:trainingcategory_2)
    
    @controller = TrainingCategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:training_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_training_category
    assert_difference('TrainingCategory.count') do
      post :create, :training_category => {:name => 'test' }
    end

    assert_redirected_to training_categories_path
  end

  def test_should_NOT_create_training_category
    assert_no_difference('TrainingCategory.count') do
      post :create, :training_category => {:name => '' } # name is required
    end

    assert_response :success
    assert_template 'new'
  end

  def test_should_get_edit
    get :edit, :id => TrainingCategory.find(:first).id
    assert_response :success
  end

  def test_should_update_training_category
    put :update, :id => TrainingCategory.find(:first).id, :training_category => {:name => 'new value' }
    assert_redirected_to training_categories_path
  end

  def test_should_NOT_update_training_category
    put :update, :id => TrainingCategory.find(:first).id, :training_category => {:name => '' }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_destroy_training_category
    assert_difference('TrainingCategory.count', -1) do
      delete :destroy, :id => Factory.build(:trainingcategory_2).id
    end

    assert_redirected_to training_categories_path
  end
end
