require File.dirname(__FILE__) + '/../test_helper'

class CustomAttributeTest < ActiveSupport::TestCase

  def test_safe_name
    assert_equal('foo_bar', Factory(:customattribute_1).safe_name)
  end
end
