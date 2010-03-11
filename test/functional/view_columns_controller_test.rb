require File.dirname(__FILE__) + '/../test_helper'
require 'view_columns_controller'

# Re-raise errors caught by the controller.
class ViewColumnsController; def rescue_action(e) raise e end; end

class ViewColumnsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:view_1)
    Factory(:column_1)
    Factory(:viewcolumn_1)
    
    @controller = ViewColumnsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_should_create_view_column
    old_count = ViewColumn.count
    view = View.find(:first)
    xhr :post, :create, :view_column => { }, :view_id => view.id, :column_id => 1
    assert_equal old_count+1, ViewColumn.count
    
    assert_response :success
    assert_template('create')
  end
  
  def test_should_NOT_create_view_column
    old_count = ViewColumn.count
    view = View.find(:first)
    xhr :post, :create, :view_column => { }, :view_id => view.id # no column_id
    assert_equal old_count, ViewColumn.count
    
    assert_redirected_to edit_view_path(view)
  end
  
  def test_should_destroy_view_column
    view = View.find(:first)
    assert_difference "ViewColumn.count", -1 do
      xhr :delete, :destroy, :id => 1, :view_id => view.id
    end
    assert_response :success
  end
end
