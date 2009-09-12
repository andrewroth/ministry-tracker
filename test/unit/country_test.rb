require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < ActiveSupport::TestCase
  fixtures Country.table_name

  test "campus list" do
    assert_equal([], countries(:usa).campus_list)
  end
end
