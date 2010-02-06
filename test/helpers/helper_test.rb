require File.dirname(__FILE__) + '/../test_helper'

class HelperTest < ActiveSupport::TestCase
  include ActionView::Helpers::UrlHelper 
  include ActionView::Helpers::TextHelper 
  include ActionView::Helpers::TagHelper
  include ApplicationHelper

  def test_display_standard_flashes
    assert true
  end
end

