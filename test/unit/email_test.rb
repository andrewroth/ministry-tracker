require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "send email to list of people" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      emails(:one).send_email
    end
  end
  
  test "send email to stored search" do
    ActionMailer::Base.deliveries = []
    assert_difference('ActionMailer::Base.deliveries.length', 2) do
      emails(:two).send_email
    end
  end
end
