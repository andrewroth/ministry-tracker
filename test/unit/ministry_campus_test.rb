require File.dirname(__FILE__) + '/../test_helper'

class MinistryCampusTest < Test::Unit::TestCase
  fixtures MinistryCampus.table_name

  def test_comparison
    first = MinistryCampus.find(1)
    second = MinistryCampus.find(2)
    assert_equal(1, first <=> second)
    assert_equal(-1, second <=> first)
  end
end
