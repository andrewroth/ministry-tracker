# $map_hash = {}
# if File.exists?( RAILS_ROOT + '/config/mappings.yml' )
#   $map_hash = File.open( RAILS_ROOT + '/config/mappings.yml' ) { |file| YAML::load(file) }
# end
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Threadsafe breaks model loading from migrations - see 
# https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2506-models-are-not-loaded-in-migrations-when-configthreadsafe-is-set

# ---
# June 3, 2009 - threadsafe removes dependency loading, which is needed
# for emu to load the canada plugin models
# ---
#config.threadsafe! unless (File.basename($0) == "rake" && !ARGV.grep(/[\w]+:/).empty?)

# Mail settings
ActionMailer::Base.delivery_method = :smtp
if Common::STAGE == "prod" && Common::SERVER == "c4c"
  ActionMailer::Base.smtp_settings = {
    :address => 'smtp.powertochange.local',
    :domain => 'powertochange.local'
  }

  ExceptionNotification::Notifier.configure_exception_notifier do |config|
    config[:app_name]                 = "[PULSE]"
    config[:subject_prepend]          = "[pulse crash] "
    config[:sender_address]           = "noreply@campusforchrist.org"
    config[:exception_recipients]     = ['andrewroth@gmail.com', 'jacques.robitaille@c4c.ca', 'sheldon.dueck@gmail.com']
    # In a local environment only use this gem to render, never email
    #defaults to false - meaning by default it sends email.  Setting true will cause it to only render the error pages, and NOT email.
    config[:skip_local_notification]  = true
    # Error Notification will be sent if the HTTP response code for the error matches one of the following error codes
    config[:notify_error_codes]   = %W( 405 500 503 )
    # Error Notification will be sent if the error class matches one of the following error classes
    config[:notify_error_classes] = %W( )
    # What should we do for errors not listed?
    config[:notify_other_errors]  = true
    # If you set this SEN will attempt to use git blame to discover the person who made the last change to the problem code
    #config[:git_repo_path]            = "/var/www/pulse.campusforchrist.org/current"
  end
else
  config.action_controller.consider_all_requests_local = true

  ActionMailer::Base.smtp_settings = {
    :address => 'localhost',
    :port => 2525,
    :domain => 'powertochange.local'
  }
end

# ExceptionNotifier.configure_exception_notifier do |config|
#   config[:exception_recipients] = ['andrewroth@gmail.com', 'josh.starcher@gmail.com']
#   config[:send_email_error_codes] = %W( 400 403 404 405 500 501 503 )
# end

if Common::STAGE == "prod"

end
