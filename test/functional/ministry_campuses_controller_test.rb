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
    xhr :get, :new
    assert_response :success
  end
  
  def test_create
    @request.session[:ministry_id] = 1 #yfc
    @count = Ministry.find(1).ministry_campuses.size
    xhr :post, :create, :campus_id => 2 #sac
    assert_response :success
    # ministries(:yfc).reload
    assert_equal @count+1, Ministry.find(1).ministry_campuses.size #yfc
  end
  
  def test_create_duplicate
    @request.session[:ministry_id] = 1 #yfc
    assert_difference('MinistryCampus.count') do
      xhr :post, :create, :campus_id => 2 #sac
    end
    assert_no_difference('MinistryCampus.count') do
      xhr :post, :create, :campus_id => 2 #sac
    end
    assert_response :success
  end
  
  def test_destroy
    test_create
    count = Ministry.find(1).ministry_campuses.size
    xhr :delete, :destroy, :id => Ministry.find(1).ministry_campuses.first.id #yfc
    assert_response :success
    # ministries(:yfc).reload
    assert_equal count-1, Ministry.find(1).ministry_campuses.size #yfc
  end
end
