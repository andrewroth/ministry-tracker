require File.dirname(__FILE__) + '/../test_helper'

class TrainingCategoryTest < ActiveSupport::TestCase

  def test_equality
    assert TrainingCategory.new(:position => 1) <=> TrainingCategory.new(:position => 2)
  end
end
