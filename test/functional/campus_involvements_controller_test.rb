require File.dirname(__FILE__) + '/../test_helper'
require 'campus_involvements_controller'

# Re-raise errors caught by the controller.
class CampusInvolvementsController; def rescue_action(e) raise e end; end

class CampusInvolvementsControllerTest < ActionController::TestCase
  fixtures CampusInvolvement.table_name, MinistryInvolvement.table_name, Person.table_name, MinistryRole.table_name

  def setup
    @controller = CampusInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_destroy_with_permission
    login
    assert_difference "CampusInvolvement.count", -1 do
      xhr :delete, :destroy, :id => 1
    end
    assert_response :success
    assert_template 'destroy'
  end
  
  def test_destroy_WITHOUT_permission
    login('sue@uscm.org')
    assert_no_difference "CampusInvolvement.count" do
      xhr :delete, :destroy, :id => 1
    end
    assert_response :success
    assert_template ''
  end
end
