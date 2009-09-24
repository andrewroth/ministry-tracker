require File.dirname(__FILE__) + '/../test_helper'

class MinistryTest < ActiveSupport::TestCase
  fixtures Ministry.table_name, MinistryCampus.table_name, View.table_name, Campus.table_name

  def test_unique_campuses
    assert_not_equal 0, Ministry.find(1).unique_campuses.length
  end
  
  def test_deleteable?
    assert !Ministry.find(4).deleteable? # root
    assert !Ministry.find(2).deleteable? # has children
    assert Ministry.find(3).deleteable? # deleteable leaf
  end
  
  def test_campus_ids
    assert_equal([1,3,2], Ministry.find(1).campus_ids)
  end
  
  def test_descendants
    assert_equal([Ministry.find(3)], Ministry.find(2).descendants)
  end
  
  def test_root
    assert_equal(Ministry.find(1), Ministry.find(2).root)
  end
  
  def test_self_plus_descendants
    assert_equal([Ministry.find(2), Ministry.find(3)], Ministry.find(2).self_plus_descendants)
  end
  
  def test_create_first_view
    assert_equal(View.find(:first).title, Ministry.create(:name => 'blah').views.first.title)
  end
end
