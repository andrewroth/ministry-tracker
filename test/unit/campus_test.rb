require File.dirname(__FILE__) + '/../test_helper'

class CampusTest < ActiveSupport::TestCase

  def test_short_name
    campus = Factory(:campus_1)
    assert_equal campus.short_name, campus.name
  end
  
  def test_equality
    campus1 = Factory(:campus_1)
    campus2 = Factory(:campus_2)
    assert campus1 <=> campus2
  end
end

