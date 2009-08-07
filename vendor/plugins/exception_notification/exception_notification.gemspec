Gem::Specification.new do |s|
  s.name = 'exception_notification'
  s.version = '1.5.0'
  s.date = '2009-08-07'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.summary = %q{Allows unhandled exceptions to be captured and sent via email}
  s.description = %q{Allows customization of:
* the sender address of the email
* the recipient addresses
* the text used to prefix the subject line
* the HTTP status codes to send emails for
* the error classes to send emails for
* alternatively, the error classes to not send emails for
* whether to send error emails or just render without sending anything
* the HTTP status and status code that gets rendered with specific errors
* the view path to the error page templates
* custom errors, with custom error templates
* define error layouts at application or controller level, or use the controller's own default layout, or no layout at all
* get error notification for errors that occur in the console, using notifiable method}
  
  s.authors = ['Peter Boling', 'Jacques Crocker', 'Jamis Buck']
  s.email = 'peter.boling@gmail.com'
  s.homepage = 'http://github.com/pboling/exception_notification'
  
  s.has_rdoc = true

  s.add_dependency 'rails', ['>= 2.1']
  
  s.files = ["MIT-LICENSE",
             "README.rdoc",
             "exception_notification.gemspec",
             "init.rb",
             "lib/exception_handler.rb",
             "lib/exception_notifiable.rb",
             "lib/exception_notifier.rb",
             "lib/exception_notifier_helper.rb",
             "lib/notifiable.rb",
             "rails/init.rb",
             "views/exception_notifiable/400.html",
             "views/exception_notifiable/403.html",
             "views/exception_notifiable/404.html",
             "views/exception_notifiable/405.html",
             "views/exception_notifiable/410.html",
             "views/exception_notifiable/501.html",
             "views/exception_notifiable/503.html",
             "views/exception_notifier/_backtrace.rhtml",
             "views/exception_notifier/_environment.rhtml",
             "views/exception_notifier/_inspect_model.rhtml",
             "views/exception_notifier/_request.rhtml",
             "views/exception_notifier/_session.rhtml",
             "views/exception_notifier/_title.rhtml",
             "views/exception_notifier/exception_notification.rhtml",
             "views/exception_notifier/background_exception_notification.rhtml",
             "VERSION.yml"]
  

  s.test_files = ["test/exception_notifier_helper_test.rb",
                  "test/exception_notify_functional_test.rb",
                  "test/test_helper.rb"]

end
