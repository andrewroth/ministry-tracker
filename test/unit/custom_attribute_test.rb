require File.dirname(__FILE__) + '/../test_helper'

class CustomAttributeTest < Test::Unit::TestCase
  fixtures CustomAttribute.table_name

  def test_safe_name
    assert_equal('foo_bar', CustomAttribute.find(:first).safe_name)
  end
end
