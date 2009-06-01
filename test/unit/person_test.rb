require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase
  fixtures Person.table_name, CustomValue.table_name, TrainingAnswer.table_name, Address.table_name, User.table_name

  def setup
    @josh = Person.find(50000)
    @sue = Person.find(2000)
  end
  
  def test_relationships
    p = Person.find(:first)
    assert_not_nil(p.campus_involvements)
    assert_not_nil(p.campuses)
    assert_not_nil(p.ministries)
  end
  
  def test_human_gender
    p = Person.new(:gender => '1')
    assert_equal p.human_gender, 'Male'
  end
  
  def test_set_gender_blank
    p = Person.new
    p.gender = ''
    assert_equal nil, p.human_gender
  end
  
  def test_initiate_addresses
    p = Person.new
    p.initialize_addresses
    assert_not_nil p.current_address
    assert_not_nil p.permanent_address
    assert_not_nil p.emergency_address
  end
  
  def test_create_value
    p = Person.find(:first)
    p.create_value(1, 'hello world')
    assert_equal p.get_value(1), 'hello world'
  end
  
  def test_set_new_value
    p = @josh
    p.set_value(1, 'goodbye world')
    assert_equal p.get_value(1), 'goodbye world'
  end
  
  def test_set_existing_new_value
    p = Person.find(:first)
    p.create_value(1, 'hello world')
    p.set_value(1, 'goodbye world')
    assert_equal p.get_value(1), 'goodbye world'
  end

  def test_set_training_date
    p = Person.find(:first)
    a = p.set_training_answer(1, Date.today, 'josh')
    assert_equal p.get_training_answer(1), a
  end
  
  def test_change_training_date
    p = Person.find(:first)
    p.set_training_answer(1, Date.today, 'josh')
    a = p.set_training_answer(1, Date.today, 'todd')
    assert_equal p.get_training_answer(1).approved_by, 'todd'
  end
  
  def test_find_exact
    #username match
    assert_equal(@josh, Person.find_exact(@josh, @josh.current_address))
    #email match
    assert_equal(@sue, Person.find_exact(@sue, @sue.current_address))
  end
  
  def test_full_name
    assert_equal('Josh Starcher', @josh.full_name)
  end
  
  def test_male?
    assert(@josh.male?)
    assert_equal(false, @sue.male?)
  end
  
  test "person should be born in the past" do
    person = Person.new
    person.first_name = "Invalid"
    person.last_name = "Birthdate Test"
    
    assert !person.valid?
    
    person.birth_date = Date.today + 1.days
    assert !person.valid?
    
    person.birth_date = Date.today - 1.days
    assert person.valid?
  end
end
