require "action_mailer"
module ExceptionNotification
  autoload :ExceptionNotifiable, 'exception_notification/exception_notifiable'
  autoload :Notifiable, 'exception_notification/notifiable'
  autoload :Notifier, 'exception_notification/notifier'
  #autoload :NotifierHelper, 'exception_notifiable/notifier_helper'
  autoload :ConsiderLocal,  'exception_notification/consider_local'
  autoload :CustomExceptionClasses,  'exception_notification/custom_exception_classes'
  autoload :CustomExceptionMethods,  'exception_notification/custom_exception_methods'
  autoload :HelpfulHashes,  'exception_notification/helpful_hashes'
  autoload :GitBlame,  'exception_notification/git_blame'
  autoload :DeprecatedMethods,  'exception_notification/deprecated_methods'
  autoload :HooksNotifier,  'exception_notification/hooks_notifier'
  autoload :NotifiableHelper,  'exception_notification/notifiable_helper'

  def self.initialize
    if defined?(ActionController::Base)
      ActionController::Base.send(:include, ExceptionNotification::ExceptionNotifiable)
    end

#TODO: Set this in gobal SEN config as the logger like they do in HoptoadNotifier
#    rails_logger = if defined?(::Rails.logger)
#                     ::Rails.logger
#                   elsif defined?(RAILS_DEFAULT_LOGGER)
#                     RAILS_DEFAULT_LOGGER
#                   end
#    HoptoadNotifier.configure(true) do |config|
#      config.logger = rails_logger
#      config.environment_name = RAILS_ENV  if defined?(RAILS_ENV)
#      config.project_root     = RAILS_ROOT if defined?(RAILS_ROOT)
#      config.framework        = "Rails: #{::Rails::VERSION::STRING}" if defined?(::Rails::VERSION)
#    end
  end
end
