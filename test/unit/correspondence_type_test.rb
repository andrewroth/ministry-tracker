require 'test_helper'

class CorrespondenceTypeTest < ActiveSupport::TestCase
  fixtures CorrespondenceType.table_name, EmailTemplate.table_name
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test_create_new_type do
    ct = CorrespondenceType.new
  end
end
