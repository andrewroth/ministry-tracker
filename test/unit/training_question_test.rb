require File.dirname(__FILE__) + '/../test_helper'

class TrainingQuestionTest < ActiveSupport::TestCase
  fixtures TrainingQuestion.table_name
  def test_safe_name
    assert_equal('fall_retreat', TrainingQuestion.find(:first).safe_name)
  end
end
