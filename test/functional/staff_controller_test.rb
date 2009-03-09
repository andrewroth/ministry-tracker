require File.dirname(__FILE__) + '/../test_helper'
require 'staff_controller'

# Re-raise errors caught by the controller.
class StaffController; def rescue_action(e) raise e end; end

class StaffControllerTest < ActionController::TestCase
  fixtures Person.table_name, MinistryInvolvement.table_name, Ministry.table_name, MinistryRole.table_name

  def setup
    @controller = StaffController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end
  
  def test_should_get_index
    get :index
    assert_response :success
  end
  
  def test_should_get_new
    get :new
    assert_response :success
  end
  # 
  # def test_should_get_demote_form
  #   @request.session[:ministry_id] = 2
  #   get :demote_form, :id => 3000
  #   assert_response :success
  #   assert_template 'demote_form'
  # end
  # 
  # def test_should_demote_a_person
  #   @request.session[:ministry_id] = 2
  #   post :demote, :id => 3000, :campus => 1
  #   assert_response :success
  #   assert_template 'demote'
  # end
end
