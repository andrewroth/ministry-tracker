require File.dirname(__FILE__) + '/../test_helper'

class PatHelperTest < ActionView::TestCase
  include Pat

  def setup
    setup_users
    setup_people
    setup_accesses
    setup_campuses
    setup_campus_involvements
    Factory(:project_1)
    Factory(:profile_1)
    Factory(:profile_2)
    Factory(:appln_1)
    Factory(:form_1)
  end

  def test_current_event_group_id
    current_event_group_id
  end

  def test_project_acceptance_totals
    results_by_campus, results_by_project = project_acceptance_totals(Campus.all.collect(&:id))
    assert results_by_campus["UoCD"][:total] == 1
    assert results_by_campus["UoCD"]["project 1"] == 1
    assert results_by_project.keys.first == "project 1"
    assert results_by_project["project 1"]["UoCD"] == 1
    assert results_by_project["project 1"][:total] == 1
  end

  def test_project_applying_totals
    results_by_campus, results_by_project = project_applying_totals(Campus.all.collect(&:id))
    assert results_by_campus["UoCD"][:total] == 1
    assert results_by_campus["UoCD"]["project 1"] == 1
    assert results_by_project.keys.first == "project 1"
    assert results_by_project["project 1"]["UoCD"] == 1
    assert results_by_project["project 1"][:total] == 1
  end

  
end
