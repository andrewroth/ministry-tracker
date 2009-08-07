Gem::Specification.new do |s|
  s.name = 'exception_notification'
  s.version = '1.4'
  s.date = '2008-07-28'
   
  s.summary = "Allows unhandled exceptions to be captured and sent via email"
  s.description = ""
  
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
                  "test/test_helper.rb"]

end
