require File.dirname(__FILE__) + '/../test_helper'

class MinistryRoleTest < ActiveSupport::TestCase

  def setup
    setup_ministry_roles
  end

  def test_comparison
    assert MinistryRole.new(:position => 1) <=> MinistryRole.new(:position => 2)
  end
  
  def test_suprior_role
    assert MinistryRole.new(:position => 1) >= MinistryRole.new(:position => 2)
  end
end
