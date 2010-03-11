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
  
  def test_to_liquid
    a = Factory(:address_1)
    a.to_liquid
    assert_equal('josh.starcher@uscm.org', a.email)
    assert_equal('847-980-1420', a.phone)
  end

  def test_sanify
    a = Factory(:address_1)
    a.sanify
    assert_nil(a.state)
  end
  
  def test_start_date
    a = Factory(:address_1)
    thedate = Time.now
    a.start_date = thedate
    assert_equal(thedate, a.start_date)
  end
  
  def test_end_date
    a = Factory(:address_1)
    thedate = Time.now
    a.end_date = thedate
    assert_equal(thedate, a.end_date)
    thedate = Date.strptime('12/15/2026', (I18n.t 'date.formats.default'))
    a.end_date = '12/15/2026'
    assert_equal(thedate, a.end_date)
  end
  
  
end
