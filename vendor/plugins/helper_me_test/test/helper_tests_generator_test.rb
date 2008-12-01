require File.dirname(__FILE__) + '/generator_test_init'

class HelperTestsGeneratorTest < GeneratorTestCase
  def setup
    super
    # this is so the generator gets found
    cp_r File.join(PLUGIN_ROOT, 'generators/helper_tests'),  File.join(RAILS_ROOT, 'vendor/generators')
    Rails::Generator::Base.use_component_sources!
  end
  
  context 'using generator with no params' do
    setup do
      run_generator('helper_tests', %w())
    end
    
    should 'create helper tests' do
      assert_generated_class 'test/helpers/blog_helper_test', 'ActionView::TestCase'
      assert_generated_class 'test/helpers/sample_helper_test', 'ActionView::TestCase'
      assert_generated_class 'test/helpers/admin/post_helper_test', 'ActionView::TestCase'
    end
    
    should 'create create tests for each method in helper' do
      assert_generated_class 'test/helpers/blog_helper_test', 'ActionView::TestCase' do |file|
        assert_has_method file, :test_post_formater, :test_date_formater
      end
      
      assert_generated_class 'test/helpers/sample_helper_test', 'ActionView::TestCase' do |file|
        assert_has_method file, :test_some_method, :test_another_helper
      end
      
      assert_generated_class 'test/helpers/admin/post_helper_test', 'ActionView::TestCase' do |file|
        assert_has_method file, :test_format_author
      end
    end
  end
  
  context 'using generator with a module parameter' do
    setup do
      run_generator('helper_tests', %w(BlogHelper))
    end
    
    should 'create just one helper test' do
      assert_generated_class 'test/helpers/blog_helper_test', 'ActionView::TestCase'
      assert_no_file_exists 'test/helpers/sample_helper_test'
      assert_no_file_exists 'test/helpers/admin/post_helper_test'
    end
  end
  
  context 'using generator with skip-method-tests option' do
    setup do
      run_generator('helper_tests', %w(--skip-method-tests BlogHelper))
    end
    
    should 'create just one helper test' do
      assert_generated_class 'test/helpers/blog_helper_test', 'ActionView::TestCase' do |file|
        assert_has_no_method file, :test_post_formater, :test_date_formater
      end
    end
  end
  
  context 'using generator with a namespaced module parameter' do
    setup do
      run_generator('helper_tests', %w(Admin::PostHelper))
    end
    
    should 'create just one helper test' do
      assert_no_file_exists 'test/helpers/blog_helper_test'
      assert_no_file_exists 'test/helpers/sample_helper_test'
      assert_generated_class 'test/helpers/admin/post_helper_test', 'ActionView::TestCase'
    end
  end
  
  context 'using generator with a complex name filesystem-path style' do
    setup do
      run_generator('helper_tests', %w(admin/post_helper))
    end
    
    should 'create just one helper test' do
      assert_no_file_exists 'test/helpers/blog_helper_test'
      assert_no_file_exists 'test/helpers/sample_helper_test'
      assert_generated_class 'test/helpers/admin/post_helper_test', 'ActionView::TestCase'
    end
  end
  
end
