require File.dirname(__FILE__) + '/../test_helper'

class ColumnTest < ActiveSupport::TestCase
  fixtures :columns

  def test_safe_name
    assert_equal Column.find(:first).safe_name, 'First_Name'
  end
end
