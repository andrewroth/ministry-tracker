require File.dirname(__FILE__) + '/../test_helper'
require 'ministries_controller'

# Re-raise errors caught by the controller.
class MinistriesController; def rescue_action(e) raise e end; end

class MinistriesControllerTest < Test::Unit::TestCase
  fixtures Ministry.table_name, MinistryInvolvement.table_name, MinistryRole.table_name, Person.table_name,
           View.table_name, Column.table_name, ViewColumn.table_name

  def setup
    @controller = MinistriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_list_ministries
    get :list
    assert_response :success
  end

  def test_should_get_new
    xhr(:get, :new)
    assert_response :success
  end
  
  def test_should_create_ministry
    old_count = Ministry.count
    post :create, :ministry => {:name => 'CCC', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States', :phone => '555',
                                :email => 'asdf' },
                  :ministry_involvement => {:ministry_role_id => 1}
    assert_equal old_count+1, Ministry.count
    assert_redirected_to ministries_path
  end
  
  def test_should_NOT_create_ministry
    old_count = Ministry.count
    post :create, :ministry => {:name => 'CCC' }
    assert_equal old_count, Ministry.count
    assert_template 'new'
  end
  
  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_ministry
    xhr :put, :update, :id => 1, :ministry => { }
    assert_response :success
  end
  
  def test_should_NOT_update_ministry
    put :update, :id => 1, :ministry => {:name => '' }
    assert_response :success
    assert_template 'edit'
  end
  
  def test_delete_ministry
    @request.session[:ministry_id] = 3 #dg
    xhr :delete, :destroy, :id => 3 #dg
    assert_response :success
  end
  
  def test_delete_ministry_UNDELETEABLE
    xhr :delete, :destroy, :id => 1 #yfc
    assert_response :success
  end
  
  def test_parent_form
    xhr :post, :parent_form
    assert_response :success
  end
  
  def test_set_parent
    @request.session[:ministry_id] = 3 #dg
    xhr :post, :set_parent, :id => 1 #yfc
    assert_response :success
  end
  
  def test_set_parent_nil
    @request.session[:ministry_id] = 3 #dg
    xhr :post, :set_parent, :id => 0
    assert_response :success
  end
  
  def test_set_parent_creating_loop_BAD
    @request.session[:ministry_id] = 1 #yfc
    xhr :post, :set_parent, :id => 2 #chicago
    assert_response :success
  end
end
