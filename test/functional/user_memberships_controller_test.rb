require File.dirname(__FILE__) + '/../test_helper'
require 'user_memberships_controller'

# Re-raise errors caught by the controller.
class UserMembershipsController; def rescue_action(e) raise e end; end

class UserMembershipsControllerTest < Test::Unit::TestCase
  fixtures UserMembership.table_name

  def setup
    @controller = UserMembershipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    xhr :get, :index
    assert_response :success
  end
  
  def test_group
    xhr :get, :group, :user_group_id => 1
    assert_response :success
  end
end
