# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
gem 'soap4r' 
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
#  config.gem "json"

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

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
end
# require 'json'
# Add new inflection rules using the following format 
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
   inflect.plural /(campus|address)$/i, '\1es'
   inflect.singular /(campus|address)es$/i, '\1'
   inflect.uncountable %w( staff customize )
end

# Add new mime types for use in respond_to blocks:
Mime::Type.register "application/vnd.ms-excel", :xls
# Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below


CAS::Filter.login_url = "https://signin.mygcx.org/cas/login"
CAS::Filter.logout_url = "https://signin.mygcx.org/cas/logout"
CAS::Filter.validate_url = "https://signin.mygcx.org/cas/serviceValidate"

ActionMailer::Base.smtp_settings = {
  :address   => "smtp1.ccci.org",
  :domain   => "ccci.org"
}
# require 'exception_notifier'
# ExceptionNotifier.sender_address = %("MinistryTrack Error" <error@ministrytrack.org>)
# ExceptionNotifier.email_prefix = "[MinistryTrack] "
# # FILTER_KEYS = %w(password)
# # ExceptionNotifier.filter_keys = FILTER_KEYS
# 
# ExceptionNotifier.exception_recipients = %w(josh.starcher@gmail.com)
