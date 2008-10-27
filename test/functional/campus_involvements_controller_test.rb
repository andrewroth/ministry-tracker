require File.dirname(__FILE__) + '/../test_helper'
require 'campus_involvements_controller'

# Re-raise errors caught by the controller.
class CampusInvolvementsController; def rescue_action(e) raise e end; end

class CampusInvolvementsControllerTest < Test::Unit::TestCase
  fixtures CampusInvolvement.table_name, MinistryInvolvement.table_name, Person.table_name

  def setup
    @controller = CampusInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_destroy_with_permission
    login
    xhr :delete, :destroy, :id => 1
    assert_response :success
    assert_template 'destroy'
  end
  
  def test_destroy_WITHOUT_permission
    login('sue@uscm.org')
    xhr :delete, :destroy, :id => 1
    assert_response :success
    assert_template ''
  end
end
