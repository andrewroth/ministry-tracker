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

    xhr :delete, :destroy, :id => 1, :members => [50000]
    assert_not_nil(::GroupInvolvement.find(1))
  end
  
  def test_transfer
    group1 = Factory(:group_3)
    group2 = Factory(:group_4)
    old_count_1 = group1.group_involvements.count
    old_count_2 = group2.group_involvements.count
    xhr :post, :transfer, :id => group2.id, :transfer_to => group1.id, :members => [50000], :level => 'leader'
    assert_equal old_count_1 + 1, group1.group_involvements.count
    assert_equal old_count_2 - 1, group2.group_involvements.count

    assert_no_difference "::GroupInvolvement.find(1).group_id" do
      xhr :post, :transfer, :id => 1, :transfer_to => 2, :members => [50000], :level => 'leader'
    end

    xhr :post, :change_level, :id => 2, :members => [1], :level => 'leader'
    assert_no_difference "::GroupInvolvement.find(3).group_id" do
      xhr :post, :transfer, :id => 2, :transfer_to => 1, :members => [50000], :level => 'leader'
    end
  end

  def test_change_level
    # test change only leader to memeber
    xhr :post, :change_level, :id => 1, :members => [50000], :level => 'member'
    assert_equal('leader', ::GroupInvolvement.find(1).level)

    xhr :post, :change_level, :id => 3, :members => [2000], :level => 'member'
    assert_equal('member', ::GroupInvolvement.find(6).level)

    xhr :post, :change_level, :id => 3, :members => [2000], :level => 'invalid level'

    xhr :post, :change_level, :id => 3, :members => [2000], :level => 'Leader'
    assert_equal('leader', ::GroupInvolvement.find(6).level)
  end

  def test_destroy_own
    xhr :post, :destroy_own, :id => 1
    assert_raise(ActiveRecord::RecordNotFound) {::GroupInvolvement.find(1)}
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

  def test_accept_request
    Factory(:groupinvolvement_7)
    xhr :post, :accept_request, :id => 7
    assert_equal(false, ::GroupInvolvement.all(:conditions => {:id => 7}).first.requested)
  end

  def test_decline_request
    Factory(:groupinvolvement_7)
    xhr :post, :decline_request, :id => 7
    assert_raise(ActiveRecord::RecordNotFound) {::GroupInvolvement.find(7)}
  end

end
