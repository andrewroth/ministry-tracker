require File.dirname(__FILE__) + '/../test_helper'

class CampusTest < ActiveSupport::TestCase
  fixtures Campus.table_name

  def test_short_name
    campus = Campus.find(:first)
    assert_equal campus.short_name, campus.name
  end
  
  def test_equality
    campus1 = Campus.find(1)
    campus2 = Campus.find(2)
    assert campus1 <=> campus2
  end
end

