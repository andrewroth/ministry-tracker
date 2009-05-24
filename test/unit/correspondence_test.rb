require File.dirname(__FILE__) + '/../test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  fixtures Correspondence.table_name

  test "should be able to make a new correspondence" do
    c = Correspondence.create! :person_id => 1, :params => { :a => 2 }, 
      :resend_delay => 5.hours
    assert_equal c.resend_delay, 5.hours
  end

  test "should stop resending if acknowledged" do
    c = correspondences(:acked)
    c.perform
    assert_equal(:ack, c.callback_tried)
  end

  test "should retry if not acknowledged and resend count not zero" do
    c = correspondences(:retry)
    c.perform
    assert_equal(:retry, c.callback_tried)
    assert_equal(c.resend_count, 2)
  end

  test "should give up if not acknowledged and retries run out" do
    c = correspondences(:giveup)
    c.perform
    assert_equal(:giveup, c.callback_tried)
  end

  test "should execute once if resend_if_not_acknowledged false" do
    c = correspondences(:once)
    c.perform
    assert_equal(:once, c.callback_tried)
  end

end
