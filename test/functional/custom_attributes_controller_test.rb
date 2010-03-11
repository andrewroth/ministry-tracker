require File.dirname(__FILE__) + '/../test_helper'
require 'custom_attributes_controller'

# Re-raise errors caught by the controller.
class CustomAttributesController; def rescue_action(e) raise e end; end

class CustomAttributesControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    Factory(:customattribute_1)

    @controller = CustomAttributesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_index
    xhr :get, :index
    assert_response :success
  end

  def test_new
    xhr :get, :new, :type => 'ProfileQuestion'
    assert_response :success
  end

  def test_edit
    xhr :get, :edit, :id => 1
    assert_response :success
  end
  
  def test_create
    old_count = CustomAttribute.count
    xhr :post, :create, :custom_attribute => { :name => "blah" }, :type => 'ProfileQuestion'
    assert_response :success
    ca = assigns(:custom_attribute)
    assert_equal "blah", ca.name
    assert_equal old_count + 1, CustomAttribute.count
  end
  
  def test_create_fail
    old_count = CustomAttribute.count
    xhr :post, :create, :profile_question => { :name => "" }, :type => 'ProfileQuestion' # no name set
    assert_response :success
    assert_equal old_count, CustomAttribute.count
  end
  
  def test_update
    xhr :put, :update, :id => 1, :profile_question => { :name => "fdas" }
    assert_response :success
    ca = assigns(:custom_attribute)
    assert_equal "fdas", ca.name
  end
  
  def test_destroy
    old_count = CustomAttribute.count
    xhr :delete, :destroy, :id => 1
    assert_equal old_count-1, CustomAttribute.count
  end
end
