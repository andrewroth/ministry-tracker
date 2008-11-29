require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  fixtures Person.table_name, Ministry.table_name, MinistryCampus.table_name,
          MinistryInvolvement.table_name,
          CampusInvolvement.table_name, Address.table_name, Group.table_name,
          View.table_name, ViewColumn.table_name, Column.table_name, ProfilePicture.table_name

  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_full_directory
    get :directory
    assert_response :success
    assert assigns(:people)
  end
  
  def test_directory_pagination
    post :directory, :search => 'all'
    assert_response :success
    assert assigns(:people)
  end
  
  def test_perform_search_by_firstname
    post :directory, :search => 'josh'
    assert_response :success
    assert assigns(:people)
  end
  
  def test_perform_search_by_fullname
    post :directory, :search => 'josh starcher'
    assert_response :success
    assert assigns(:people)
  end
  
  def test_perform_search_by_email
    post :directory, :search => 'josh.starcher@uscm.org'
    assert_response :success
    assert assigns(:people)
  end
  
  def test_directory_paginate_Z
    post :directory, :first => 'Z', :finish => ''
    assert_response :success
    assert assigns(:people)
  end
  
  def test_search_full_name
    xhr :post, :search, :search => 'Josh Starcher', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end
  
  def test_search_first_name
    xhr :post, :search, :search => 'Josh', :context => 'group_involvements', :group_id => 2, :type => 'leader'
    assert_response :success
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_re_create_staff
    old_count = Person.count
    post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                  :current_address => {:email => "josh.starcher@uscm.org"}
    assert_equal old_count, Person.count
    assert_redirected_to person_path(assigns(:person))
  end
  
  def test_should_create_student
    assert_difference "Delayed::Job.count" do
      old_count = Person.count
      post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => '1' }, 
                    :current_address => {:email => "josh.starcsher@gmail.org"}, :student => true,
                    :modalbox => 'true', :ministry_role_id => 4,  :campus => Campus.find(:first).id
      assert person = assigns(:person)
      assert_not_nil person.user.id
      assert_equal old_count+1, Person.count
      assert_redirected_to person_path(assigns(:person))
    end
  end
  
  # def test_should_create_student_with_username_conflict # Not likely to ever happen
  #   old_count = Person.count
  #   test_should_create_student
  #   post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
  #                 :current_address => {:email => "josh.starcher@gmail.org"}, :student => true
  #   assert person = assigns(:person)
  #   assert_equal old_count+1, Person.count
  #   assert_redirected_to person_path(assigns(:person))
  # end
  
  def test_should_re_create_student
    old_count = Person.count
    post :create, :person => {:first_name => 'Josh', :last_name => 'Starcher', :gender => 'Male' }, 
                  :current_address => {:email => "josh.starcher@uscm.org"}, :student => true
    assert person = assigns(:person)
    assert_equal old_count, Person.count
    assert_redirected_to person_path(assigns(:person))
  end
  
  def test_should_NOT_create_person
    old_count = Person.count
    post :create, :person => { }
    assert_equal old_count, Person.count
    assert_response :success
    assert_template 'new'
  end

  def test_should_show_person
    get :show, :id => 50000
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 50000
    assert_response :success
  end
  
  def test_should_update_person
    xhr :put, :update, :id => 50000, :person => {:first_name => 'josh', :last_name => 'starcher' }, 
                       :current_address => {:email => "josh.starcher@uscm.org"}, 
                       :perm_address => {:phone => '555-555-5555', :address1 => 'here'}
    assert_template '_view'
  end
  
  def test_should_NOT_update_person
    xhr :put, :update, :id => 50000, :person => {:first_name => '' }
    assert_response :success
    assert_template '_edit'
  end
  
  # def test_should_destroy_person
  #   old_count = Person.count
  #   delete :destroy, :id => 50000
  #   assert_equal old_count-1, Person.count
  #   
  #   assert_redirected_to people_path
  # end
  
  def test_change_ministry
    xhr :post, :change_ministry, :ministry => 1
    assert_response :success
  end
end
