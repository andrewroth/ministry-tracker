require File.dirname(__FILE__) + '/../test_helper'

class PeopleHelperTest < ActionView::TestCase

  def test_parse_url
    url = 'http://jlstarcher.com'
    assert_equal(['jlstarcher', url], parse_url(url))
  end

end
