require File.dirname(__FILE__) + '/../test_helper'

class TrainingHelperTest < ActionView::TestCase
  include ApplicationHelper
  # fixtures Person.table_name, TrainingQuestion.table_name
  # 
  def setup
    setup_default_user
    Factory(:trainingquestion_1)
  end

  def test_training_question_field
    @my = Person.first
    assert_tag_in(training_question_field(TrainingQuestion.first, Person.first), :script)
  end

end
