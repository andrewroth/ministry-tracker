require File.dirname(__FILE__) + '/../test_helper'
require 'dorms_controller'

# Re-raise errors caught by the controller.
class DormsController; def rescue_action(e) raise e end; end

class DormsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:dorm_1)
    Factory(:dorm_2)
    setup_ministry_roles

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
  
  def test_create
    xhr :post, :create, :dorm => {:campus_id => 2, :name => 'Primero Grove'}
    assert assigns(:dorm)
    assert_response :success
  end
  
  def test_destroy
    assert_difference 'Dorm.count', -1 do
      xhr :delete, :destroy, :id => '1'
    end
    assert_response :success
  end
end
