require File.dirname(__FILE__) + '/../test_helper'
require 'dorms_controller'

# Re-raise errors caught by the controller.
class DormsController; def rescue_action(e) raise e end; end

class DormsControllerTest < Test::Unit::TestCase
  fixtures Dorm.table_name, Group.table_name

  def setup
    @controller = DormsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_list
    xhr :post, :list, :campus_id => 2
    assert assigns(:dorms)
    assert_response :success
  end
end
