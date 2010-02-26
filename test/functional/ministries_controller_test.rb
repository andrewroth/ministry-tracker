require File.dirname(__FILE__) + '/../test_helper'

class MinistriesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_ministry_roles
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
    assert_difference('Ministry.count') do
      post :create, :ministry => {:name => 'CCC', :address => 'here', :city => 'there', 
                                  :state => 'IL', :country => 'United States', :phone => '555',
                                  :email => 'asdf' },
                    :ministry_involvement => {:ministry_role_id => 1}
    end
    assert_redirected_to ministries_path
  end
  
  def test_should_NOT_create_ministry
    assert_no_difference('Ministry.count') do
      post :create, :ministry => {:name => '' }
    end
    assert_template 'new'
  end
  
  # This changes the active ministry
  def test_should_get_edit
    xhr :get, :edit, :id => 1
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
    ministry = Factory(:ministry_3)
    @request.session[:ministry_id] = ministry.id
    xhr :delete, :destroy, :id => ministry.id
    assert_response :success
  end
  
  def test_delete_ministry_UNDELETEABLE
    xhr :delete, :destroy, :id => 1 #yfc
    assert_response :success
  end
  
  def test_delete_removes_only_ministrys_roles
    Factory(:ministry_3)
    Factory(:ministry_7)
    xhr :delete, :destroy, :id => 3
    assert_response :success
    assert_nil Ministry.find_by_id(3)
    assert MinistryRole.find_by_ministry_id(6) #passes
    assert MinistryRole.find_by_ministry_id(1) #this fails
    assert_nil MinistryRole.find_by_ministry_id(3) # this too, but is blocked by the above fail.
  end
  
  
  
  def test_parent_form
    xhr :post, :parent_form
    assert_response :success
  end
  
  def test_set_parent
    @request.session[:ministry_id] = 3 #dg
    xhr :post, :set_parent, :id => 3, :parent_id => 1 #yfc
    assert_response :success
  end
  
  def test_set_parent_nil
    @request.session[:ministry_id] = 3 #dg
    xhr :post, :set_parent, :parent_id => 0, :id => 3
    assert_response :success
  end
  
  def test_set_parent_creating_loop_BAD
    @request.session[:ministry_id] = 1 #yfc
    xhr :post, :set_parent, :id => 1, :parent_id => 2 #chicago
    assert_response :success
  end
end
