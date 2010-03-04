require File.dirname(__FILE__) + '/../test_helper'
require 'columns_controller'

# Re-raise errors caught by the controller.
class ColumnsController; def rescue_action(e) raise e end; end

class ColumnsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_ministry_roles
    Factory(:column_1)
    
    @controller = ColumnsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:columns)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_column
    old_count = Column.count
    post :create, :column => {:title => "Middle Name", :select_clause => 'middle_name', :from_clause => 'Person' }
    assert_equal old_count+1, Column.count
    
    assert_redirected_to columns_path
  end
  
  def test_should_fail_create_validation_column
    old_count = Column.count
    post :create, :column => { }
    assert_equal old_count, Column.count
    
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_column
    put :update, :id => 1, :column => {:title => "Middle Name", :select_clause => 'middle_name', :from_clause => 'Person' }
    assert_redirected_to columns_path
  end
  
  def test_should_NOT_update_column
    put :update, :id => 1, :column => {:title => "", :select_clause => 'middle_name', :from_clause => 'Person' }
    assert_response :success
    column = assigns(:column)
    assert_equal column.errors.count, 1
  end
  
  def test_should_destroy_column
    old_count = Column.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Column.count
    
    assert_redirected_to columns_path
  end
end
