require File.dirname(__FILE__) + '/../test_helper'
require 'views_controller'

# Re-raise errors caught by the controller.
class ViewsController; def rescue_action(e) raise e end; end

class ViewsControllerTest < Test::Unit::TestCase
  fixtures View.table_name, Ministry.table_name, ViewColumn.table_name

  def setup
    @controller = ViewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:views)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_view
    old_count = View.count
    post :create, :view => {:title => 'new view' }
    assert_equal old_count+1, View.count
    
    assert_redirected_to edit_view_path(assigns(:view))
  end
  
  def test_should_NOT_create_view
    old_count = View.count
    post :create, :view => {:title => '' } # blank title
    assert_equal old_count, View.count
    
    assert_response :success
    assert_template('new')
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_view
    put :update, :id => 1, :view => {:default_view => 1 }
    assert_redirected_to views_path()
  end
  
  def test_should_NOT_update_view
    put :update, :id => 1, :view => {:title => '' }
    assert_response :success
    assert_template('edit')
  end
  
  def test_should_destroy_view
    # add a second view
    3.times do |i| View.create!(:ministry_id => 1, :title => 'hi mom') end # make sure ther's more than one view
    assert_difference 'View.count', -1 do
      delete :destroy, :id => 1
    end
    
    assert_redirected_to views_path
  end
  
  def test_reorder
    old_order = View.find(1).view_columns.collect(&:id).map(&:to_s)
    new_order = ["2", "3", "1"]
    put :reorder, :id => 1, :column_list => new_order
    assert_equal(new_order, View.find(1).view_columns.collect(&:id).map(&:to_s))
    
  end
end
