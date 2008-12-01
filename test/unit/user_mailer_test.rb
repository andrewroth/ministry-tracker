require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase
  fixtures Person.table_name, Ministry.table_name, User.table_name

  test "created student" do
    UserMailer.deliver_created_student(Person.find(50000), Ministry.first, Person.first, 'password')
    assert_equal(1, ActionMailer::Base.deliveries.length)
  end
  
  test "created student without password" do
    assert_raises(StandardError) do
      UserMailer.deliver_created_student(Person.find(50000), Ministry.first, Person.first, '')
    end
  end
  
  # test "created staff" do
  #    UserMailer.deliver_created_staff(Person.find(50000), Ministry.first, Person.first, 'password')
  #   assert_equal(1, ActionMailer::Base.deliveries.length)
  # end
end
