require File.dirname(__FILE__) + '/../test_helper'

class GroupInvolvementTest < ActiveSupport::TestCase

  def setup
    setup_groups
  end

  # Replace this with your real tests.
  def test_join_notifications
    gi = GroupInvolvement.find 5
    gi.join_notifications("base_url")
  end
end
