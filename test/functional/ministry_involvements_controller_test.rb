require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_involvements_controller'

# Re-raise errors caught by the controller.
class MinistryInvolvementsController; def rescue_action(e) raise e end; end

class MinistryInvolvementsControllerTest < Test::Unit::TestCase
  fixtures MinistryInvolvement.table_name

  def setup
    @controller = MinistryInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_destroy
    xhr :delete, :destroy, :id => 1, :person_id => 50000
    assert assigns(:ministry_involvement)
    assert_response :success
  end
  
  def test_destroy_only_one_ministry
    xhr :delete, :destroy, :id => 1, :person_id => 3000
    assert_nil assigns(:ministry_involvement)
    assert_response :success
  end
end
