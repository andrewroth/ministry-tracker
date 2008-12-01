require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>HelperTest < ActionView::TestCase
<% for hmethod in helper_methods %>
  def test_<%= hmethod %>
    flunk
  end
<% end %>
end
