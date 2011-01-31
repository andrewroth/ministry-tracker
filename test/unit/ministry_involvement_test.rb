require File.dirname(__FILE__) + '/../test_helper'

class MinistryInvolvementTest < ActiveSupport::TestCase

  def setup
  end


  test "change year in school if role is alumni" do
    Factory(:person_3)
    Factory(:campus_2)
    Factory(:ministry_1)
    Factory(:schoolyear_1)
    Factory(:schoolyear_10)
    Factory(:ministryrole_3)
    Factory(:ministryrole_11)
    Factory(:ministryinvolvement_4)
    Factory(:campusinvolvement_2)
    Factory(:campusinvolvement_4)

    Factory(:person_3).campus_involvements.each do |ci|
      assert_not_equal "Graduated", ci.school_year.name
    end

    mi = Factory(:person_3).ministry_involvements.first
    mi.ministry_role = MinistryRole.first(:conditions => {:name => "Alumni"})
    mi.save!

    # should change all campus involvements to be Graduated
    Factory(:person_3).campus_involvements.each do |ci|
      assert_equal "Graduated", ci.school_year.name
    end
  end


end
