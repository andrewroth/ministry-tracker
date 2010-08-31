require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test exception_notifiable gem.'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

desc 'Generate documentation for exception_notifiable gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'exception_notifiable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "super_exception_notifier"
    gemspec.summary = "Allows unhandled (and handled!) exceptions to be captured and sent via email"
    gemspec.description = "Allows customization of:
* Specify which level of notification you would like with an array of optional styles of notification (email, webhooks)
* the sender address of the email
* the recipient addresses
* the text used to prefix the subject line
* the HTTP status codes to notify for
* the error classes to send emails for
* alternatively, the error classes to not notify for
* whether to send error emails or just render without sending anything
* the HTTP status and status code that gets rendered with specific errors
* the view path to the error page templates
* custom errors, with custom error templates
* define error layouts at application or controller level, or use the controller's own default layout, or no layout at all
* get error notification for errors that occur in the console, using notifiable method
* Override the gem's handling and rendering with explicit rescue statements inline.
* Hooks into `git blame` output so you can get an idea of who (may) have introduced the bug
* Hooks into other website services (e.g. you can send exceptions to to Switchub.com)
* Can notify of errors occurring in any class/method using notifiable { method }
* Can notify of errors in Rake tasks using NotifiedTask.new instead of task
* Works with Hoptoad Notifier, so you can notify via SEN and/or Hoptoad for any particular errors.
* Tested with Rails 2.3.x, should work with rails 2.2.x, and is apparently not yet compatible with rails 3."
    gemspec.email = "peter.boling@gmail.com"
    gemspec.homepage = "http://github.com/pboling/exception_notification"
    gemspec.authors = ['Peter Boling', 'Scott Windsor', 'Ismael Celis', 'Jacques Crocker', 'Jamis Buck']
    gemspec.add_dependency 'actionmailer'
    gemspec.add_dependency 'rake'
    gemspec.files = ["MIT-LICENSE",
             "README",
             "CHANGELOG.txt",
             "super_exception_notifier.gemspec",
             "init.rb",
             "lib/exception_notification/consider_local.rb",
             "lib/exception_notification/custom_exception_classes.rb",
             "lib/exception_notification/custom_exception_methods.rb",
             "lib/exception_notification/deprecated_methods.rb",
             "lib/exception_notification/exception_notifiable.rb",
             "lib/exception_notification/git_blame.rb",
             "lib/exception_notification/helpful_hashes.rb",
             "lib/exception_notification/hooks_notifier.rb",
             "lib/exception_notification/notifiable.rb",
             "lib/exception_notification/notifiable_helper.rb",
             "lib/exception_notification/notified_task.rb",
             "lib/exception_notification/notifier.rb",
             "lib/exception_notification/notifier_helper.rb",
             "lib/exception_notification.rb",
             "rails/init.rb",
             "rails/app/views/exception_notifiable/400.html",
             "rails/app/views/exception_notifiable/403.html",
             "rails/app/views/exception_notifiable/404.html",
             "rails/app/views/exception_notifiable/405.html",
             "rails/app/views/exception_notifiable/410.html",
             "rails/app/views/exception_notifiable/418.html",
             "rails/app/views/exception_notifiable/422.html",
             "rails/app/views/exception_notifiable/423.html",
             "rails/app/views/exception_notifiable/500.html",
             "rails/app/views/exception_notifiable/501.html",
             "rails/app/views/exception_notifiable/503.html",
             "rails/app/views/exception_notifiable/method_disabled.html.erb",
             "lib/views/exception_notification/notifier/_backtrace.html.erb",
             "lib/views/exception_notification/notifier/_environment.html.erb",
             "lib/views/exception_notification/notifier/_inspect_model.html.erb",
             "lib/views/exception_notification/notifier/_request.html.erb",
             "lib/views/exception_notification/notifier/_session.html.erb",
             "lib/views/exception_notification/notifier/_title.html.erb",
             "lib/views/exception_notification/notifier/background_exception_notification.text.plain.erb",
             "lib/views/exception_notification/notifier/exception_notification.text.plain.erb",
             "lib/views/exception_notification/notifier/rake_exception_notification.text.plain.erb",
             "VERSION.yml"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
