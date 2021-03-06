require File.dirname(__FILE__) + '/../test_helper'
require 'group_involvements_controller'

# Re-raise errors caught by the controller.
class GroupInvolvementsController; def rescue_action(e) raise e end; end

class GroupInvolvementsControllerTest < ActionController::TestCase

  def setup
    setup_default_user
    setup_groups

    @controller = GroupInvolvementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login
  end

  def test_create
    xhr :post, :create, :person_id => 50000, :group_id => 2, :level => 'leader'
    assert gi = assigns(:gi)
    assert_equal gi.level, 'leader'
    assert_response :success
  end
  
  def test_destroy
    assert_difference "GroupInvolvement.count", -1 do
      xhr :delete, :destroy, :id => 3, :members => [50000]
    end
  end
  
  def test_transfer
    group1 = Factory(:group_3)
    group2 = Factory(:group_4)
    old_count_1 = group1.group_involvements.count
    old_count_2 = group2.group_involvements.count
    xhr :post, :transfer, :id => group2.id, :transfer_to => group1.id, :members => [50000], :level => 'leader'
    assert_equal old_count_1 + 1, group1.group_involvements.count
    assert_equal old_count_2 - 1, group2.group_involvements.count
  end

  def test_join_interested
    assert_difference "GroupInvolvement.count", 1 do
      xhr :post, :joingroup, :group_id => 1, :level => 'interested',
            :gt_id => 1, :person_id => 2 
    end
    assert_no_match /Are you sure you want to delete/, @response.body
  end

  def test_join_member
    assert_difference "GroupInvolvement.count", 1 do
      xhr :post, :joingroup, :group_id => 1, :level => 'member',
            :gt_id => 1, :person_id => 2 
    end
  end

  def test_join_level_check
    assert_difference "GroupInvolvement.count", 0 do
      xhr :post, :joingroup, :group_id => 1, :level => 'leader',
            :gt_id => 1, :person_id => 2 
    end
    assert_match /invalid level/, @response.body
  end
end
