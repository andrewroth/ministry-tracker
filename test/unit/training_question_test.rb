require File.dirname(__FILE__) + '/../test_helper'

class TrainingQuestionTest < ActiveSupport::TestCase

  def test_safe_name
    tq = Factory(:trainingquestion_1)
    assert_equal('fall_retreat', tq.safe_name)
  end
end
