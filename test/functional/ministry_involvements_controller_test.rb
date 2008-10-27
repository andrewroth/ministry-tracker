require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_involvements_controller'

# Re-raise errors caught by the controller.
class MinistryInvolvementsController; def rescue_action(e) raise e end; end

class MinistryInvolvementsControllerTest < ActionController::TestCase
  fixtures MinistryInvolvement.table_name

  def setup
    @controller = MinistryInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  test "destroy" do
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert assigns(:ministry_involvement)
    assert_response :success
  end
  
  test "destroy only one ministry" do
    xhr :delete, :destroy, :id => 1, :person_id => 3000
    assert_nil assigns(:ministry_involvement)
    assert_response :success
  end
  
  test "edit own role" do
    xhr :get, :edit, :person_id => 50000, :ministry_id => 2
    assert_response :success
    assert_template 'edit'
  end
  
  test "edit someone else's role" do
    xhr :get, :edit, :person_id => 3000, :ministry_id => 2
    assert_response :success
    assert_template 'edit'
  end
  
  test "edit with bad parameters" do
    assert_raise(RuntimeError) { xhr :get, :edit }
  end
  
  test "update role" do
    old_mi = MinistryInvolvement.find(1)
    xhr :put, :update, :id => 1, :ministry_involvement => {:ministry_role => 'Student Leader'}
    assert mi = assigns(:ministry_involvement)
    assert_not_equal old_mi.ministry_role, mi.ministry_role
  end
end
