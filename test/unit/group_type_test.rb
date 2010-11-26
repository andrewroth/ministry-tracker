require File.dirname(__FILE__) + '/../test_helper'

class GroupTypeTest < ActiveSupport::TestCase

  def setup
    setup_campuses
    setup_ministries
    setup_groups
    setup_semesters
  end

  def test_update_collection_groups
    current_semester = Factory(:current_semester)
    next_semester = Factory(:next_semester)

    campus = Campus.first

    first_group = campus.find_or_create_ministry_group(Factory(:grouptype_4), Ministry.first, current_semester)
    second_group = campus.find_or_create_ministry_group(Factory(:grouptype_4), Ministry.first, next_semester)
    
    Factory(:grouptype_4).update_collection_groups

    assert_equal "#{campus.short_desc} interested in a #{Factory(:grouptype_4).group_type} for #{current_semester.desc}", first_group.name
    assert_equal "#{campus.short_desc} interested in a #{Factory(:grouptype_4).group_type} for #{next_semester.desc}", second_group.name

    group_type = GroupType.find(4)
    group_type.collection_group_name = "People interested in a group of the type {{group_type}} from the campus {{campus}} for the semester of {{semester}}"
    group_type.save!
    
    Factory(:grouptype_4).update_collection_groups

    assert_equal "People interested in a group of the type #{Factory(:grouptype_4).group_type} from the campus #{campus.short_desc} for the semester of #{current_semester.desc}", Group.find(first_group.id).name
    assert_equal "People interested in a group of the type #{Factory(:grouptype_4).group_type} from the campus #{campus.short_desc} for the semester of #{next_semester.desc}", Group.find(second_group.id).name
  end
end
