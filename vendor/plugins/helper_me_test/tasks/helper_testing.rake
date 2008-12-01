desc 'Run all unit, functional, helper and integration tests'
task :test do
  errors = %w(test:units test:functionals test:helpers test:integration).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end

namespace :test do
  Rake::TestTask.new(:helpers => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/helpers/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:units'].comment = "Run the helper tests in test/helpers"
end
