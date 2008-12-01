# This is so the initializer is properly found
$:.unshift Gem.searcher.find('rails_generator').full_gem_path + '/lib'
ENV["RAILS_ENV"] = "test"
if defined? PLUGIN_ROOT
  PLUGIN_ROOT.replace File.expand_path(File.join(File.dirname(__FILE__), '..'))
else
  PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
end

require 'test/unit'
require 'fileutils'
require 'rubygems'
require 'shoulda'
require 'active_support'
require 'active_support/test_case'

# Set RAILS_ROOT appropriately fixture generation
tmp_dir = "#{File.dirname(__FILE__)}/fixtures/tmp"

if defined? RAILS_ROOT
  RAILS_ROOT.replace tmp_dir
else
  RAILS_ROOT = tmp_dir
end
FileUtils.mkdir_p RAILS_ROOT

require 'initializer'

# Mocks out the configuration
module Rails
  def self.configuration
    Rails::Configuration.new
  end
end

require 'rails_generator'

# Mocks the admin module so helpers loads propery
module Admin; end

class GeneratorTestCase < ActiveSupport::TestCase
  include FileUtils
  
  def setup
    mkdir_p "#{RAILS_ROOT}/app"
    mkdir_p "#{RAILS_ROOT}/config"
    mkdir_p "#{RAILS_ROOT}/test"
    mkdir_p "#{RAILS_ROOT}/vendor/generators"
    
    cp_r File.join(PLUGIN_ROOT, 'test/fixtures/helpers'), File.join(RAILS_ROOT, 'app')
    
    # ensures helpers are found
    $: << File.join(RAILS_ROOT, 'app/helpers')
    %w(sample_helper blog_helper admin/post_helper).each do |h|
      require h
    end

    File.open("#{RAILS_ROOT}/config/routes.rb", 'w') do |f|
      f << "ActionController::Routing::Routes.draw do |map|\n\nend"
    end
  end

  def teardown
    %w(app test config vendor).each do |dir|
      rm_rf File.join(RAILS_ROOT, dir)
    end
  end
  
  # Instantiates the Generator.
  def build_generator(name, params)
    Rails::Generator::Base.instance(name, params)
  end

  # Runs the +create+ command (like the command line does).
  def run_generator(name, params)
    silence_generator do
      build_generator(name, params).command(:create).invoke!
    end
  end

  # Silences the logger temporarily and returns the output as a String.
  def silence_generator
    logger_original = Rails::Generator::Base.logger
    myout = StringIO.new
    Rails::Generator::Base.logger = Rails::Generator::SimpleLogger.new(myout)
    yield if block_given?
    Rails::Generator::Base.logger = logger_original
    myout.string
  end
  
  # Asserts that the given helper was generated.
  # It takes a name or symbol without the <tt>_helper</tt> part.
  # The contents of the module source file is passed to a block.
  def assert_generated_helper_for(name)
    assert_generated_module "app/helpers/#{name.to_s.underscore}_helper" do |body|
      yield body if block_given?
    end
  end
  
  # Asserts that the given file was generated.
  # The contents of the file is passed to a block.
  def assert_generated_file(path)
    assert_file_exists(path)
    File.open("#{RAILS_ROOT}/#{path}") do |f|
      yield f.read if block_given?
    end
  end

  # asserts that the given file exists
  def assert_file_exists(path)
    assert File.exist?("#{RAILS_ROOT}/#{path}"),
      "The file '#{RAILS_ROOT}/#{path}' should exist"
  end
  
  # asserts that the given file does not exists
  def assert_no_file_exists(path)
    assert !File.exist?("#{RAILS_ROOT}/#{path}"),
      "The file '#{RAILS_ROOT}/#{path}' should not exist"
  end

  # Asserts that the given class source file was generated.
  # It takes a path without the <tt>.rb</tt> part and an optional super class.
  # The contents of the class source file is passed to a block.
  def assert_generated_class(path, parent = nil)
    # FIXME: Sucky way to detect namespaced classes
    if path.split('/').size > 3
      path =~ /\/?(\d+_)?(\w+)\/(\w+)$/
      class_name = "#{$2.camelize}::#{$3.camelize}"
    else
      path =~ /\/?(\d+_)?(\w+)$/
      class_name = $2.camelize
    end

    assert_generated_file("#{path}.rb") do |body|
      assert_match /class #{class_name}#{parent.nil? ? '':" < #{parent}"}/, body, "the file '#{path}.rb' should be a class"
      yield body if block_given?
    end
  end

  # Asserts that the given module source file was generated.
  # It takes a path without the <tt>.rb</tt> part.
  # The contents of the class source file is passed to a block.
  def assert_generated_module(path)
    # FIXME: Sucky way to detect namespaced modules
    if path.split('/').size > 3
      path =~ /\/?(\w+)\/(\w+)$/
      module_name = "#{$1.camelize}::#{$2.camelize}"
    else
      path =~ /\/?(\w+)$/
      module_name = $1.camelize
    end

    assert_generated_file("#{path}.rb") do |body|
      assert_match /module #{module_name}/, body, "the file '#{path}.rb' should be a module"
      yield body if block_given?
    end
  end
  
  # Asserts that the given methods are defined in the body.
  # This does assume standard rails code conventions with regards to the source code.
  # The body of each individual method is passed to a block.
  def assert_has_method(body, *methods)
    methods.each do |name|
      assert body =~ /^\s*def #{name}(\(.+\))?\n((\n|   .*\n)*)  end/, "should have method #{name}"
      yield(name, $2) if block_given?
    end
  end
  
  def assert_has_no_method(body, *methods)
    methods.each do |name|
      assert body !~ /^\s*def #{name}(\(.+\))?\n((\n|   .*\n)*)  end/, "should have method #{name}"
    end
  end
  
end
