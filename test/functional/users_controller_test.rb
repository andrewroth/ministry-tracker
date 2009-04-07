require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  fixtures User.table_name

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_user
    old_count = User.count
    post :create, :user => {:username => 'josh.starcher' }
    assert_equal old_count+1, User.count
    
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_NOT_create_user
    old_count = User.count
    post :create, :user => { }
    assert_equal old_count, User.count
    assert_response :success
    assert_template 'new'
  end

  def test_should_get_rest
    get "/people.xml"
    
    assert_response HTTP::Status::OK
    assert_equal 'application/xml', @response.content_type

    with_options :tag => 'person' do |person|
      person.assert_tag :children => { :count => 1, :only => { :tag => 'bio' } }
    end
  end

  def test_should_show_user
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_user
    put :update, :id => 1, :user => { }
    assert assigns(:user)
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_NOT_update_user
    put :update, :id => 1, :user => {:username => '' }
    assert_response :success
    assert_template 'edit'
  end
  
  def test_should_destroy_user
    old_count = User.count
    delete :destroy, :id => 1
    assert_equal old_count-1, User.count
    
    assert_redirected_to users_path
  end
end
