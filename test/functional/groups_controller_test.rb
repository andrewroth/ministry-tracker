require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase
 
  def setup
    login
  end
  
  def test_index
    get :index
    assert_response :success
  end

  def test_index_xhr
    login
    xhr :get, :index
    assert_response :success
  end
  
  def test_show
    login
    xhr :get, :show, :id => 2
    assert assigns(:group)
    assert_response :success
    assert_template('show')
  end
  
  def test_edit
    login
    xhr :get, :edit, :id => 2
    assert assigns(:group)
    assert_response :success
    assert_template('edit')
  end
  
  def test_update
    login
    xhr :put, :update, :id => 2, :group => {:name => "Frosh", }
    assert bs = assigns(:group)
    assert_equal bs.name, "Frosh"
    assert_response :success
    assert_template('update')
  end
  
  def test_should_get_new
    login
    xhr(:get, :new)
    assert_response :success
  end
  
  def test_should_create
    login
    old_count = Group.count
    post :create, :group => {:name => 'CCC', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 }
    assert_equal old_count+1, Group.count
  end
  
  def test_should_NOT_create
    login
    old_count = Group.count
    post :create, :group => {:name => '' }
    assert_equal old_count, Group.count
    assert_template 'new'
  end
    
  def test_delete
    login
    xhr :delete, :destroy, :id => 2
    assert_response :success
  end
end
