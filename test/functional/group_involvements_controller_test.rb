require File.dirname(__FILE__) + '/../test_helper'
require 'group_involvements_controller'

# Re-raise errors caught by the controller.
class GroupInvolvementsController; def rescue_action(e) raise e end; end

class GroupInvolvementsControllerTest < ActionController::TestCase
  fixtures GroupInvolvement.table_name, Person.table_name, Group.table_name, Address.table_name

  def setup
    @controller = GroupInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_create
    xhr :post, :create, :person_id => 50000, :group_id => 2, :type => 'leader'
    assert gi = assigns(:gi)
    assert_equal gi.level, 'leader'
    assert_response :success
  end
  
  def test_destroy
    old_count = GroupInvolvement.count
    delete :destroy, :id => 1, :members => [50000]
    assert_equal old_count-1, GroupInvolvement.count
  end
  
  def test_destroy_fail
    assert_raise(RuntimeError) {
      delete :destroy, :id => 1  
    }
  end
  
  def test_transfer
    group1 = Group.find(1)
    group2 = Group.find(2)
    old_count_1 = group1.group_involvements.count
    old_count_2 = group2.group_involvements.count
    post :transfer, :id => group1.id, :transfer_to => group2.id, :members => [50000], :level => 'leader'
    assert_equal old_count_1 - 1, group1.group_involvements.count
    assert_equal old_count_2 + 1, group2.group_involvements.count
  end
end
