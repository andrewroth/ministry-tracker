require File.dirname(__FILE__) + '/../test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  fixtures Correspondence.table_name

  def setup
    @count_before = Correspondence.count
  end

  # note - creating correspondences on the fly rather than using fixtures
  # so that delayed jobs are also made
  test "should be able to make a new correspondence" do
    c = Correspondence.create! :person_id => 1, :params => { :a => 2 }
    assert_equal(@count_before + 1, Correspondence.count)
  end

  test "should stop resending if acknowledged" do
    c = CorrespondenceNightly.create_delayed(1, {})
    c.acknowledged = true
    c.perform
    assert_equal(:acked, c.callback_tried)
    assert_equal(@count_before, Correspondence.count)
  end

  test "should send if not acknowledged and resend count not zero" do
    c = CorrespondenceNightly.create_delayed(1, {})
    c.perform
    assert_equal(:delivered, c.callback_tried)
    assert_equal(@count_before + 1, Correspondence.count)
  end

  test "should give up if not acknowledged and retries run out" do
    c = CorrespondenceNightly.create_delayed(1, {})
    c.delayed_job.executions_left = 0
    c.perform
    assert_equal(:gaveup, c.callback_tried)
    assert_equal(@count_before, Correspondence.count)
  end

  test "should create a delayed job on CorrespondenceNightly" do
    CorrespondenceNightly.create_delayed 1, {}
    assert_equal(1, Delayed::Job.count)
    dj = Delayed::Job.find(:first)
    tn = Time.now.utc
    tmor = Time.now.tomorrow.utc
    assert_equal(tn.year, dj.run_at.year)
    assert_equal(tn.month, dj.run_at.month)
    assert_equal(Time.now.hour > 3 ? tmor.day : tn.day, dj.run_at.day)
    assert_equal(3, dj.run_at.hour)
  end

  test "should finish delayed_job on destroy" do
    c = CorrespondenceNightly.create_delayed 2, {}
    c.delayed_job.period = 0
    c.delayed_job.run_at = Time.now
    c.delayed_job.save!
    assert_equal(1, Delayed::Job.count)
    Delayed::Job.work_off(4) # CorrespondenceNightly sends once then retries 3 times
    assert_equal(0, Delayed::Job.count)
  end
end
