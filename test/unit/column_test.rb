require File.dirname(__FILE__) + '/../test_helper'

class ColumnTest < ActiveSupport::TestCase

  def test_safe_name
    assert_equal Factory(:column_1).safe_name, 'First_Name'
  end
end
