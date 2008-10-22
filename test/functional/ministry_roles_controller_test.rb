require File.dirname(__FILE__) + '/../test_helper'
require 'ministry_roles_controller'

# Re-raise errors caught by the controller.
class MinistryRolesController; def rescue_action(e) raise e end; end

class MinistryRolesControllerTest < Test::Unit::TestCase
  fixtures MinistryRole.table_name

  def setup
    @controller = MinistryRolesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
