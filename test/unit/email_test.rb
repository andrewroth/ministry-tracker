require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase

  def setup
    reset_people_sequences

    @person = factory(:person)
    @person_1 = factory(:person_1)
    @email_1 = factory(:email_1)
    @email_2 = factory(:email_2)
    factory(:search_1)
    factory(:address_1)
    factory(:address_2)
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
