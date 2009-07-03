require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_campuses_controller'

# Re-raise errors caught by the controller.
class MinistryCampusesController; def rescue_action(e) raise e end; end

class MinistryCampusesControllerTest < ActionController::TestCase
  fixtures MinistryCampus.table_name, Campus.table_name, Ministry.table_name

  def setup
    @controller = MinistryCampusesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_index
    xhr :get, :index, :ministry_id => 1 #yfc
    assert_response :success
  end
  
  def test_list
    xhr :get, :list, :ministry_id => 1 #yfc
    assert_response :success
  end

  def test_new
    xhr :get, :new, :ministry_id => 1
    assert_response :success
  end
  
  def test_create
    assert_difference('MinistryCampus.count') do
      xhr :post, :create, :campus_id => 2, :ministry_id => 1
    end
    assert_response :success
  end
  
  def test_create_duplicate
    assert_difference('MinistryCampus.count') do
      xhr :post, :create, :campus_id => 2, :ministry_id => 1
    end
    assert_no_difference('MinistryCampus.count') do
      xhr :post, :create, :campus_id => 2, :ministry_id => 1
    end
    assert_response :success
  end
  
  def test_destroy
    test_create
    assert_difference('MinistryCampus.count', -1) do
      xhr :delete, :destroy, :id => Ministry.find(1).ministry_campuses.first.id #yfc
    end
    assert_response :success
  end
  
  
  def test_report
  	get :show, :id => MinistryCampus.find(:first).id
  	assert_response :success 
  end
  
  def test_show_another_min_camp
  	old = MinistryCampus.find(:first)
  	new = MinistryCampus.find_last_by_ministry_id old.ministry_id
  	put :update, :id => old.id, :new_camp => new.id
  	assert_not_equal old, assigns(:cur_min_camp)
  	assert_response :success 
  end
  
  
  #this fails, but the log shows that it shouldn't, as it does save a new tree head id in the right place. 
  #I don't know why this isn't passing then, oldtreeheadid != newtreeheadid in the log.
  def test_change_tree_head
  	old_tree_head_id = ministry_campuses(:three).tree_head_id
  	put :update, :id => ministry_campuses(:three).id, :tree_head_id => 3000
  	assert_response :success
  	assert_not_equal old_tree_head_id, ministry_campuses(:three).tree_head_id
  end
  
  
  
  
  
  
  
  
  
  
end
