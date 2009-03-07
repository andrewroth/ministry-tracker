require 'test_helper'

class <%= helper_full_name %>Test < ActionView::TestCase
<% unless options[:skip_method_tests] -%>
<% for hmethod in helper_methods %>
  def test_<%= hmethod %>
    flunk
  end
<% end %>
<% end -%>
end
