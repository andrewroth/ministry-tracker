require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < ActiveSupport::TestCase

  def test_mailing
    a = Factory(:address_1)
    assert_equal "108 E. Burlington Ave.<br />Westmont, WY 60559", a.mailing
    a = Factory(:address_2)
    assert_equal ' ', a.mailing
  end
  
  def test_mailing_one_line
    a = Factory(:address_1)
    assert_equal "108 E. Burlington Ave., Westmont, WY 60559", a.mailing_one_line
  end
  
  def test_address_types
    assert_equal('current', CurrentAddress.create(:person_id => '50000', :email => 'example@example.com').address_type)
    assert_equal('emergency1', EmergencyAddress.create(:person_id => '50000', :email => 'example@example.com').address_type)
    assert_equal('permanent', PermanentAddress.create(:person_id => '50000', :email => 'example@example.com').address_type)
  end
end
