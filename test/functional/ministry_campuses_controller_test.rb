require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_campuses_controller'

# Re-raise errors caught by the controller.
class MinistryCampusesController; def rescue_action(e) raise e end; end

class MinistryCampusesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    @controller = MinistryCampusesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_index
    xhr :get, :index #yfc
    assert_response :success
  end
  
  def test_list
    xhr :get, :list, :ministry_id => 1 #yfc
    assert_response :success
  end

  def test_new
    Cmt::CONFIG[:campus_scope_country] = nil
    xhr :get, :new, :ministry_id => 1
    assert_response :success
  end
  
  def test_new_with_campus_scope_country
    Cmt::CONFIG[:campus_scope_country] = 'US'
    xhr :get, :new, :ministry_id => 1
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
end
