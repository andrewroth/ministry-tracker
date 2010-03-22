ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'factory_girl'

Dir[Rails.root.join("vendor/plugins/mh_common/test/factories/**/*.rb")].each do |file|
  require file
end

Dir[Rails.root.join("vendor/plugins/movement_tracker_canada/test/factories/*")].each do |file|
  require file
end

class ActiveSupport::TestCase
  include ActionController::TestProcess
  include Test::TestHelper
end
