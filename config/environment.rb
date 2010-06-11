# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# For emailer use
DEVELOPMENT_HOST = 'localhost:3000'
TEST_HOST = 'localhost:3000'
PRODUCTION_HOST = 'example.com'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  require "#{RAILS_ROOT}/vendor/plugins/git_branch_configs/init"

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  cmt_config = "#{RAILS_ROOT}/config/initializers/cmt_config"
  require cmt_config if File.exists?("#{cmt_config}.rb")

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  # config.gem  'json'
  config.gem  'json_pure', :lib => 'json'
  config.gem  'fastercsv'
  config.gem  'hpricot'
  config.gem  'rubyzip', :lib => 'zip/zip'
  config.gem  'roo', :version => '1.3.11'
  config.gem  'mechanize'
  config.gem  'erubis'
  config.gem  'aws-s3', :lib => 'aws/s3'
  config.gem  'jrails'
  config.gem  'spreadsheet'
  # config.gem  'rubycas-client'
  config.gem 'liquid'
  config.gem 'facebooker' if defined?(Cmt) && Cmt::CONFIG[:facebook_connectivity_enabled]
  config.gem 'will_paginate'
  
  config.time_zone = 'UTC'

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  config.action_controller.session = { :session_key => "_sn_session", :secret => "01855ec2cf5b05f6f66d1f116dd69116" }
  
  # config.active_record.observers = :view_column_observer
  # config.plugins = config.plugin_locators.map do |locator|
  #                    locator.new(Rails::Initializer.new(config)).plugins
  #                  end.flatten.map{|p| p.name.to_sym}
  # 
  # config.plugins -= [:query_trace]
  config.action_controller.use_accept_header = true
  
  # The internationalization framework can be changed 
  # to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  if File.exists?(File.join(RAILS_ROOT, 'config', 'initializers', 'cmt_config.example')) && !File.exists?(File.join(RAILS_ROOT, 'config', 'initializers', 'cmt_config.rb'))
    require 'fileutils'
    FileUtils.cp(File.join(RAILS_ROOT, 'config', 'initializers', 'cmt_config.example'), File.join(RAILS_ROOT, 'config', 'initializers', 'cmt_config.rb'))
  end
end
