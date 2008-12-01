require File.dirname(__FILE__) + '/../test_helper'
require 'teams_controller'

# Re-raise errors caught by the controller.
class TeamsController; def rescue_action(e) raise e end; end

class TeamsControllerTest < Test::Unit::TestCase
  fixtures Group.table_name

  def setup
    @controller = TeamsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_index_xhr
    xhr :get, :index
    assert_response :success
  end
  
  def test_show
    xhr :get, :show, :id => 1
    assert assigns(:team)
    assert_response :success
    assert_template('show')
  end
  
  def test_edit
    xhr :get, :edit, :id => 1
    assert assigns(:team)
    assert_response :success
    assert_template('edit')
  end
  
  def test_update
    xhr :put, :update, :id => 1, :team => {:name => "Frosh", }
    assert team = assigns(:team)
    assert_equal team.name, "Frosh"
    assert_response :success
    assert_template('update')
  end
  
  def test_should_get_new
    xhr(:get, :new)
    assert_response :success
  end
  
  def test_should_create_team
    old_count = Team.count
    post :create, :team => {:name => 'CCC', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf' }
    assert_equal old_count+1, Team.count
  end
  
  def test_should_NOT_create_team
    old_count = Team.count
    post :create, :team => {:name => '' }
    assert_equal old_count, Team.count
    assert_template 'new'
  end
    
  def test_delete_team
    xhr :delete, :destroy, :id => 1
    assert_response :success
  end
end
