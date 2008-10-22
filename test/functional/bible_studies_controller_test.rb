require File.dirname(__FILE__) + '/../test_helper'
require 'bible_studies_controller'

# Re-raise errors caught by the controller.
class BibleStudiesController; def rescue_action(e) raise e end; end

class BibleStudiesControllerTest < Test::Unit::TestCase
  fixtures Group.table_name

  def setup
    @controller = BibleStudiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    xhr :get, :index
    assert_response :success
  end
  
  def test_show
    xhr :get, :show, :id => 2
    assert assigns(:bible_study)
    assert_response :success
    assert_template('show')
  end
  
  def test_edit
    xhr :get, :edit, :id => 2
    assert assigns(:bible_study)
    assert_response :success
    assert_template('edit')
  end
  
  def test_update
    xhr :put, :update, :id => 2, :bible_study => {:name => "Frosh", }
    assert bs = assigns(:bible_study)
    assert_equal bs.name, "Frosh"
    assert_response :success
    assert_template('update')
  end
  
  def test_should_get_new
    xhr(:get, :new)
    assert_response :success
  end
  
  def test_should_create_bible_study
    old_count = BibleStudy.count
    post :create, :bible_study => {:name => 'CCC', :address => 'here', :city => 'there', 
                                :state => 'IL', :country => 'United States',
                                :email => 'asdf' }
    assert_equal old_count+1, BibleStudy.count
  end
  
  def test_should_NOT_create_bs
    old_count = BibleStudy.count
    post :create, :bible_study => {:name => '' }
    assert_equal old_count, BibleStudy.count
    assert_template 'new'
  end
    
  def test_delete_bs
    xhr :delete, :destroy, :id => 2
    assert_response :success
  end
end
