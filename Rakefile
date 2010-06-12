# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

begin
  require 'tasks/facebooker'
rescue
end

# require 'rubygems'
# require "deep_test/rake_tasks"

# sample DeepTest task
# 
# DeepTest::TestTask.new "test_all" do |t|
#   t.number_of_workers = 2   # optional, defaults to 2
#   t.timeout_in_seconds = 30 # optional, defaults to 30
#   t.server_port = 6969      # optional, defaults to 6969
#   t.pattern = "test/**/*_test.rb"
#   t.libs << "test" # may be necessary for Rails >= 2.1.x
# end
