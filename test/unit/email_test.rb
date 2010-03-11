require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase

  def setup
    reset_people_sequences

    @person = Factory(:person)
    @person_1 = Factory(:person_1)
    @email_1 = Factory(:email_1)
    @email_2 = Factory(:email_2)
    Factory(:search_1)
    Factory(:address_1)
    Factory(:address_2)
  end

  test "send email to list of people" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      @email_1.send_email
    end
  end
  
  test "send email to stored search" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      @email_2.send_email
    end
  end

  test "send email substitutes first/last name properly" do
    ActionMailer::Base.deliveries = []
    @email_1.send_email
    assert_equal @email_1.render_body(@person_1), "Josh Starcher"
  end
end
