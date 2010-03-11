require File.dirname(__FILE__) + '/../test_helper'

class MinistryTest < ActiveSupport::TestCase

  @data_loaded = false
  def load_data
    if !@data_loaded
      @m = [nil, 
            Factory(:ministry_1), 
            Factory(:ministry_2), 
            Factory(:ministry_3), 
            Factory(:ministry_4), 
            Factory(:ministry_5), 
            Factory(:ministry_6), 
            Factory(:ministry_7)]
      Factory(:ministrycampus_1)
      Factory(:ministrycampus_2)
      Factory(:ministrycampus_3)
      Factory(:campus_1)
      Factory(:campus_2)
      Factory(:campus_3)
      @data_loaded = true
    end
  end

  def setup
    load_data
  end

  def test_unique_campuses
    assert_not_equal 0, @m[1].unique_campuses.length
  end
  
  def test_deleteable?
    assert !@m[4].deleteable? # root
    assert !@m[2].deleteable? # has children
    assert @m[3].deleteable? # deleteable leaf
  end
  
  def test_campus_ids
    assert_equal([1,3,2], @m[1].campus_ids)
  end
  
  def test_descendants
    assert_equal([@m[3]], @m[2].descendants)
  end
  
  def test_root
    assert_equal(@m[1], @m[2].root)
  end
  
  def test_self_plus_descendants
    assert_equal([@m[2], @m[3]], @m[2].self_plus_descendants)
  end
  
  def test_create_first_view
    assert_equal(View.find(:first).title, Ministry.create(:name => 'blah').views.first.title)
  end
end
