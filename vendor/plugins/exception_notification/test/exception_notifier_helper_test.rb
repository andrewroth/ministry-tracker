require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'exception_notifier_helper'

class ExceptionNotifierHelperTest < Test::Unit::TestCase

  class ExceptionNotifierHelperIncludeTarget
    include ExceptionNotifierHelper
  end

  def setup
    @helper = ExceptionNotifierHelperIncludeTarget.new
  end

  # No controller

  def test_should_not_exclude_raw_post_parameters_if_no_controller
    assert !@helper.exclude_raw_post_parameters?
  end

  # Controller, no filtering

  class ControllerWithoutFilterParameters; end

  def test_should_not_filter_env_values_for_raw_post_data_keys_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert_equal "secret", @helper.filter_sensitive_post_data_from_env("RAW_POST_DATA", "secret")
  end
  def test_should_not_filter_env_values_for_any_keys_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert_equal "secret", @helper.filter_sensitive_post_data_from_env("SOME_OTHER_KEY", "secret")
  end
  def test_should_not_exclude_raw_post_parameters_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert !@helper.exclude_raw_post_parameters?
  end
  def test_should_return_params_if_controller_can_not_filter_parameters
    stub_controller(ControllerWithoutFilterParameters.new)
    assert_equal :params, @helper.filter_sensitive_post_data_parameters(:params)
  end

  # Controller with filter paramaters method, no params to filter

  class ControllerWithFilterParameters
    def filter_parameters(params)
      params.keys.each do |k|
        params[k] = :filtered
      end
      params
    end
  end

  def test_should_filter_env_values_for_raw_post_data_keys_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    
    assert_equal("[FILTERED]", @helper.filter_sensitive_post_data_from_env("RAW_POST_DATA", "secret"))
    assert_equal(:filtered, @helper.filter_sensitive_post_data_from_env("SOME_OTHER_KEY", "secret"))
  end
  def test_should_exclude_raw_post_parameters_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParametersThatDoesntFilter.new)
    assert @helper.exclude_raw_post_parameters?
  end
  def test_should_delegate_param_filtering_to_controller_if_controller_can_filter_parameters
    stub_controller(ControllerWithFilterParameters.new)
    assert_equal({:param => :filtered}, @helper.filter_sensitive_post_data_parameters({:param => :value}))
  end

  private
    def stub_controller(controller)
      @helper.instance_variable_set(:@controller, controller)
    end
end