require File.dirname(__FILE__) + '/../test_helper'

class TrainingQuestionsControllerTest < ActionController::TestCase
  def setup
    setup_default_user
    Factory(:trainingquestion_1)
    Factory(:trainingcategory_1)
    
    login
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_training_question
    assert_difference('TrainingQuestion.count') do
      xhr :post, :create, :training_question => {:activity => 'test' , :ministry_id => 1, :training_category_id => 1}
      assert q = assigns(:training_question)
      assert_equal([], q.errors.full_messages)
    end
    assert_response :success, @response.body
  end

  def test_should_NOT_create_training_question
    assert_no_difference('TrainingQuestion.count') do
      post :create, :training_question => {:activity => '' } # name is required
    end

    assert_response :success
    assert_template 'new'
  end

  def test_should_get_edit
    get :edit, :id => TrainingQuestion.find(:first).id
    assert_response :success
  end

  def test_should_update_training_question
    put :update, :id => TrainingQuestion.find(:first).id, :training_question => {:activity => 'new value' }
    assert_response :success, @response.body
  end

  def test_should_NOT_update_training_question
    put :update, :id => TrainingQuestion.find(:first).id, :training_question => {:activity => '' }
    assert_response :success
    assert_template 'update'
  end

  def test_should_destroy_training_question
    assert_difference('TrainingQuestion.count', -1) do
      delete :destroy, :id => TrainingQuestion.find(:first).id
    end

    assert_response :success, @response.body
  end
end
