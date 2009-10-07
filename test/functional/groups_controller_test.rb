require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase
 
  def setup
    login
  end
  
  def test_index
    get :index
    assert_response :success
    assert_equal [ Group.first ], assigns('groups')
  end

  def test_join
    get :join
    assert_response :success
    assert_equal [ Group.first ], assigns('person_campus_groups')
  end

  def test_join_request_campus_chosen
    p = Person.find 50000
    p.campus_involvements.delete_all
    get :join
    assert_response :success
    assert flash[:notice] =~ /You do not have a campus chosen/
  end

  def test_index_all
    get :index, :all => 'true'
    assert_response :success
    assert_equal Ministry.first.groups.sort{ |g1, g2| g1.name <=> g2.name }, assigns('groups')
  end
  # 
  # def test_index_xhr
  #   login
  #   xhr :get, :index
  #   assert_response :success
  # end
  
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
  
  def test_should_get_new_and_post_and_create
    login
    session[:group] = nil
    assert_difference("Group.count") do
      xhr(:get, :new)
      assert_response :success
      post :create, :group => {:name => 'Water Water Water', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf', :group_type_id => 1 }    
    end
    assert_not_nil assigns(:group) 
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
    post :create, :group => {:name => '' }, :isleader => '1'
    assert_equal old_count, Group.count
    assert_template 'new'
  end

  def test_delete
    login
    xhr :delete, :destroy, :id => 2
    assert_response :success
  end

  def test_compare_timetables
    login
    get :compare_timetables, :id => 1
  end
end
