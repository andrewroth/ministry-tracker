require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < ActionView::TestCase
  fixtures Person.table_name, CustomAttribute.table_name
  
  
  def test_spinner
    assert_tag_in(spinner, :img)
  end

  def test_date_options
    assert_equal({:include_blank => true, :start_year => 2005}, date_options(2005))
  end
  
  def test_times
    assert_equal(2, times(0,900).length)
  end
  
  def test_custom_text_field
    assert_tag_in(custom_field(CustomAttribute.first,Person.first), :input, :attributes => {:type => "text"})
  end
  
  def test_custom_check_box_field
    assert_tag_in(custom_field(CustomAttribute.find(2),Person.first), :input, :attributes => {:type => "checkbox"})
  end
  
  def test_custom_text_area_field
    assert_tag_in(custom_field(CustomAttribute.find(3),Person.first), :textarea)
  end
  
  def test_custom_date_select_field
    assert_tag_in(custom_field(CustomAttribute.find(4),Person.first), :script)
  end
  # 
  # def test_update_flash
  #   flunk
  # end
  # 
  def test_fancy_date_field
    assert_tag_in(fancy_date_field('foo', Date.today), :input)
    assert_tag_in(fancy_date_field('foo', Date.today), :script)
  end
  # 
  # def test_hide_spinner
  #   flunk
  # end

end
