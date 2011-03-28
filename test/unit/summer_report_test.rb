require 'test_helper'

class SummerReportTest < ActiveSupport::TestCase

  def setup
    setup_years
    setup_months
    setup_weeks
    setup_users
    setup_people
    setup_default_user
    setup_summer_reports
  end


  test "has a week" do
    sr = Factory(:summer_report_1)

    assert_equal true, sr.valid?
    sr.summer_report_weeks.destroy_all
    assert_equal false, sr.valid?
  end

  test "has a reviewer" do
    sr = Factory(:summer_report_1)

    assert_equal true, sr.valid?
    sr.summer_report_reviewers.destroy_all
    assert_equal false, sr.valid?
  end

  test "accountability partner if doing mpd" do
    sr = Factory(:summer_report_1)

    assert_equal true, sr.valid?
    sr.accountability_partner = nil
    assert_equal false, sr.valid?
    sr.num_weeks_of_mpd = 0
    assert_equal true, sr.valid?
  end

  test "approved" do
    sr = Factory(:summer_report_1)

    assert_equal true, sr.approved?
    assert_equal SummerReport::STATUS_APPROVED, sr.status
  end

  test "reviewed" do
    sr = Factory(:summer_report_1)

    assert_equal true, sr.reviewed?
  end

  test "disapproved" do
    sr = Factory(:summer_report_1)
    r = sr.summer_report_reviewers.first
    r.reviewed = true
    r.approved = false
    r.save

    assert_equal true, sr.disapproved?
    assert_equal SummerReport::STATUS_DISPROVED, sr.status
  end

  test "waiting" do
    sr = Factory(:summer_report_1)
    sr.summer_report_reviewers.each {|r| r.reviewed = nil; r.approved = nil;}

    assert_equal SummerReport::STATUS_WAITING, sr.status
  end

  test "status style" do
    sr = Factory(:summer_report_1)

    assert_equal String, sr.status_style.type
  end
end
