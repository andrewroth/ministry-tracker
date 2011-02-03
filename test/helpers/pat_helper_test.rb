require File.dirname(__FILE__) + '/../test_helper'

class PatHelperTest < ActionView::TestCase
  include Pat

  def setup
    setup_users
    setup_people
    setup_campuses
    setup_campus_involvements
    Factory(:campusinvolvement_8)
    Factory(:campusinvolvement_9)
    Factory(:campusinvolvement_10)
    Factory(:campusinvolvement_11)
#    Factory(:user_9)
#    Factory(:user_10)
#    Factory(:user_11)
    Factory(:project_1)
    Factory(:project_2)
    Factory(:profile_1)
    Factory(:profile_2)
    Factory(:profile_3)
    Factory(:profile_4)
    Factory(:profile_5)
    Factory(:appln_1)
    Factory(:form_1)
  end

  def test_current_event_group_id
    current_event_group_id
  end

  def test_project_acceptance_totals
    results_by_campus, results_by_project = project_acceptance_totals(Campus.all.collect(&:id), nil)
    assert_equal 1, results_by_campus["UCD"][:total]
    assert_equal 2, results_by_campus["Wy"]["project 2"]
    assert_equal 1, results_by_project["project 1"]["UCD"]
    assert_equal 2, results_by_project["project 1"][:total]
    assert_equal 2, results_by_project["project 2"]["Wy"]
    assert_equal 2, results_by_project["project 2"][:total]
  end

  def test_project_applying_totals
    results_by_campus, results_by_project = project_applying_totals(Campus.all.collect(&:id))
    assert results_by_campus["UCD"][:total] == 1
    assert_equal 1, results_by_campus["Wy"]["project 2"]
    assert_equal 1, results_by_project["project 1"]["UCD"]
    assert_equal 2, results_by_project["project 1"][:total]
    assert_equal 1, results_by_project["project 2"]["Wy"]
    assert_equal 1, results_by_project["project 2"][:total]
  end
end
