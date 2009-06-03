# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :test do
  desc "Generate code coverage with rcov"
  task :coverage do
    rm_f "doc/coverage/coverage.data"
    rm_f "doc/coverage"
    mkdir "doc/coverage"
    rcov = %(rcov --rails --aggregate doc/coverage/coverage.data --text-summary -Ilib --html -o doc/coverage test/unit/*_test.rb)
    rcov = %(rcov --rails --aggregate doc/coverage/coverage.data --text-summary -Ilib --html -o doc/coverage test/functional/*_test.rb)    
    rcov = %(rcov --rails --aggregate doc/coverage/coverage.data --text-summary -Ilib --html -o doc/coverage test/integration/*_test.rb)        
    r = system rcov
    system "open doc/coverage/index.html" if (PLATFORM['darwin'] && r && $? == 0)
  end
end

