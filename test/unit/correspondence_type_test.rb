require File.dirname(__FILE__) + '/../test_helper'

class CorrespondenceTypeTest < ActiveSupport::TestCase
  fixtures CorrespondenceType.table_name, EmailTemplate.table_name

  def test_create_new_type
    ct = CorrespondenceType.new
  end
end
