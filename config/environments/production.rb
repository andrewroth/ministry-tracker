# $map_hash = {}
# if File.exists?( RAILS_ROOT + '/config/mappings.yml' )
#   $map_hash = File.open( RAILS_ROOT + '/config/mappings.yml' ) { |file| YAML::load(file) }
# end
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
#
# Ugly hack to remove cache_classes when running from rake - see 
#  http://whatcodecraves.com/articles/2009/03/17/rails_2.2.2_chicken_and_egg_migrations_headache/
#  https://rails.lighthouseapp.com/projects/8994/tickets/802-eager-load-application-classes-can-block-migration
config.cache_classes = (File.basename($0) == "rake" && !ARGV.grep(/db:/).empty?) ? false : true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.threadsafe!

