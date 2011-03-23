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


  test "validates week exists" do
    sr = Factory(:summer_report_1)

    sr.summer_report_weeks.destroy_all

    assert_equal false, sr.valid?
  end
end
