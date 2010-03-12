require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
#  Person, CustomValue, TrainingAnswer, 
#  Address, User,
#  Ministry, GroupInvolvement, GroupType, Group


  def setup
    setup_n_campus_involvements(10)
    setup_addresses
    setup_campuses
    setup_ministries
    setup_school_years
    setup_ministry_roles
    setup_users
    setup_ministry_involvements
    setup_groups
    @josh = Person.find(50000)
    @sue = Person.find(2000)
    @personfirst = Person.find(1)
    @person2 = Person.find(2)    
  end
  
  
  def test_create_value
    @personfirst.create_value(1, 'hello world')
    assert_equal @personfirst.get_value(1), 'hello world'
  end
  
  def test_set_new_value
    p = @josh
    p.set_value(1, 'goodbye world')
    assert_equal p.get_value(1), 'goodbye world'
  end
  
  def test_set_existing_new_value
    p = @personfirst
    p.create_value(1, 'hello world')
    p.set_value(1, 'goodbye world')
    assert_equal p.get_value(1), 'goodbye world'
  end

  def test_set_training_date
    p = @personfirst
    a = p.set_training_answer(1, Date.today, 'josh')
    assert_equal p.get_training_answer(1), a
  end
  
  def test_change_training_date
    p = @personfirst
    p.set_training_answer(1, Date.today, 'josh')
    a = p.set_training_answer(1, Date.today, 'todd')
    assert_equal p.get_training_answer(1).approved_by, 'todd'
  end
  
  test "person should be born in the past" do
    person = Person.new
    person.first_name = "Invalid Birth Date Test"

    assert person.valid?
    
    person.birth_date = Date.today + 1.days
    assert !person.valid?
    
    person.birth_date = Date.today - 1.days
    assert person.valid?
  end

  test "group_involvements_by_group_type should filter by ministry" do
    person = @josh
    assert_equal 2, person.ministry_involvements.length
    assert_equal 1, person.group_group_involvements(:all, :ministry => Ministry.first).length
  end

  test "is_leading_group_with? works" do
    assert_equal true, @josh.is_leading_group_with?(@person2)
  end
  
  test "is_leading_mentor_priority_group_with? works" do
    assert_equal true, @josh.is_leading_mentor_priority_group_with?(@person2)
    gt = Group.find(3).group_type
    gt.mentor_priority = false
    gt.save!
    assert_equal false, @josh.is_leading_mentor_priority_group_with?(@person2)
  end

end
