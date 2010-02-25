require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase

  def load_ministries
    @ministry_yfc = Factory(:ministry_1) 
    Factory(:ministry_2) 
    Factory(:ministry_3) 
    Factory(:ministry_4) 
    Factory(:ministry_5) 
    Factory(:ministry_6) 
    Factory(:ministry_7)
  end

  def load_persons
    @josh = Factory(:person_1)
  end
  
  def load_users
    Factory(:user_1)
  end

  @data_loaded = false
  def load_data
    if !@data_loaded
      load_persons
      load_ministries
      load_users
      
      @data_loaded = true
    end
  end


  def setup
    load_data
  end


  test "created student" do
    UserMailer.deliver_created_student(@josh, Ministry.first, Person.first, 'password')
    assert_equal(1, ActionMailer::Base.deliveries.length)
  end
  
  test "created student without password" do
    assert_raises(StandardError) do
      UserMailer.deliver_created_student(@josh, Ministry.first, Person.first, '')
    end
  end
  
end
