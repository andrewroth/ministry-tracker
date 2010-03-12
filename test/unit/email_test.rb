require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase

  def setup
    Factory(:person)
    Factory(:person_1)
    Factory(:user_1)
    Factory(:access_1)
    Factory(:email_1)
    Factory(:email_2)
    Factory(:search_1)
    Factory(:address_1)
    Factory(:address_2)
  end

  test "send email to list of people" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      Factory(:email_1).send_email
    end
  end
  
  test "send email to stored search" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      Factory(:email_2).send_email
    end
  end

  test "send email substitutes first/last name properly" do
    ActionMailer::Base.deliveries = []
    Factory(:email_1).send_email
    assert_equal Factory(:email_1).render_body(Factory(:person_1)), "Josh Starcher"
  end
end
