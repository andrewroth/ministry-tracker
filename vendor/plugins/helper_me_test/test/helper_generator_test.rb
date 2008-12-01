require File.dirname(__FILE__) + '/generator_test_init'

class HelperGeneratorTest < GeneratorTestCase
  def setup
    super
    # this is so the generator gets found
    cp_r File.join(PLUGIN_ROOT, 'generators/helper'),  File.join(RAILS_ROOT, 'vendor/generators')
    Rails::Generator::Base.use_component_sources!
  end
  
  context 'running generator with simple name' do
    setup do
      run_generator('helper', %w(Tags))
      require 'tags_helper'
    end
    
    should 'create helper' do
      assert_generated_helper_for :tags
    end
    
    should 'create helper tests' do
      assert_generated_class 'test/helpers/tags_helper_test', 'ActionView::TestCase'
    end
  end
  
  context 'running generator with complex name' do
    setup do
      run_generator('helper', %w(Admin::Tags))
      require 'admin/tags_helper'
    end
    
    should 'create helper' do
      assert_generated_helper_for 'Admin::Tags'
    end
    
    should 'create helper tests' do
      assert_generated_class 'test/helpers/admin/tags_helper_test', 'ActionView::TestCase'
    end
  end
  
  context 'running generator with method names' do
    setup do
      run_generator('helper', %w(Tags format sort to_html))
      require 'tags_helper'
    end
    
    should 'create helper with methods' do
      assert_generated_helper_for :tags do |helper|
        assert_has_method helper, :format, :sort, :to_html
      end
    end
    
    should 'create helper tests with methods' do
      assert_generated_class 'test/helpers/tags_helper_test', 'ActionView::TestCase' do |test|
        assert_has_method test, :test_format, :test_sort, :test_to_html
      end
    end
  end
  
end
