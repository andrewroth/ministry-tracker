require File.dirname(__FILE__) + '/../test_helper'

class MinistryCampusTest < ActiveSupport::TestCase

  def setup
    Factory(:ministry_1)
    Factory(:ministry_2)
    Factory(:campus_1)
    Factory(:campus_2)
    Factory(:ministrycampus_1)
    Factory(:ministrycampus_2)
  end

  def test_comparison
    first = MinistryCampus.find(1)
    second = MinistryCampus.find(2)
    assert_equal(1, first <=> second)
    assert_equal(-1, second <=> first)
  end
end
