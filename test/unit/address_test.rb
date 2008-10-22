require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures Address.table_name

  def test_mailing
    a = Address.find(1)
    assert_equal "108 E. Burlington Ave.<br />Westmont, IL 60559", a.mailing
    a = Address.find(2)
    assert_equal ' ', a.mailing
  end
  
  def test_mailing_one_line
    a = Address.find(1)
    assert_equal "108 E. Burlington Ave., Westmont, IL 60559", a.mailing_one_line
  end
  
  def test_address_types
    assert_equal('current', CurrentAddress.create(:person_id => '50000').address_type)
    assert_equal('emergency1', EmergencyAddress.create(:person_id => '50000').address_type)
    assert_equal('permanent', PermanentAddress.create(:person_id => '50000').address_type)
  end
end
