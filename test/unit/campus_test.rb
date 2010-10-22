require File.dirname(__FILE__) + '/../test_helper'

class CampusTest < ActiveSupport::TestCase

  def setup
    setup_n_campus_involvements(10)
    setup_campuses
    setup_ministries
    setup_ministry_roles
    setup_people
    setup_users
    Factory(:access_1)
    Factory(:access_3)
    setup_ministry_involvements
    setup_groups
    setup_semesters
  end

  def test_find_or_create_ministry_group
    current_semester = Factory(:current_semester)
    next_semester = Factory(:next_semester)

    campus = Campus.first

    first_group = campus.find_or_create_ministry_group(Factory(:grouptype_4), Ministry.first, current_semester)

    first_group.find_or_create_involvement(Factory(:user_1).person, "#{Group::LEADER}")
    first_group.find_or_create_involvement(Factory(:user_3).person, "#{Group::CO_LEADER}")
    assert_equal Factory(:user_1).person, first_group.leaders[0]
    assert_equal Factory(:user_3).person, first_group.co_leaders[0]

    assert_equal "#{campus.short_desc} interested in a #{Factory(:grouptype_4).group_type} for #{current_semester.desc}", first_group.name
    assert_equal Factory(:grouptype_4).id, first_group.group_type_id

    
    second_group = campus.find_or_create_ministry_group(Factory(:grouptype_4), Ministry.first, next_semester)

    assert_equal "#{campus.short_desc} interested in a #{Factory(:grouptype_4).group_type} for #{next_semester.desc}", second_group.name
    assert_equal Factory(:grouptype_4).id, second_group.group_type_id

    assert_array_similarity first_group.leaders, second_group.leaders
    assert_array_similarity first_group.co_leaders, second_group.co_leaders
  end


end
