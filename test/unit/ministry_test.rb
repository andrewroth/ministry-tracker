require File.dirname(__FILE__) + '/../test_helper'

class MinistryTest < ActiveSupport::TestCase

  def setup
    setup_ministries
    setup_ministry_campuses
    setup_campuses
    setup_ministry_roles
    setup_people
    setup_ministry_involvements
    setup_ministry_roles
    setup_ministry_campuses
    @m = Hash[*Ministry.all.collect{|m| [m.id, m]}.flatten]
  end

  def test_create_first_view
    new_ministry = Ministry.create!(:name => 'new')
    assert_equal(View.last.title, new_ministry.views.first.title)
  end
end
