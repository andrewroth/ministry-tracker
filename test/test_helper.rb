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

module Test
  module TestHelper
    def setup_timetables
      Factory(:timetable_1)
      Factory(:timetable_2)
      Factory(:freetime_1)
      Factory(:freetime_2)
      Factory(:freetime_3)
      Factory(:freetime_4)
    end
  end
end
