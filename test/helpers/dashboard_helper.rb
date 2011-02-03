require File.dirname(__FILE__) + '/../test_helper'

class DashboardHelperTest < ActionView::TestCase
  def test_no_zero
    assert_equal("", no_zero(0))
  end

  def test_toggle_campus(c)
    toggle_campus("campus")
  end
end
