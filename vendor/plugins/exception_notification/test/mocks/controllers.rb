module Rails
  def self.public_path
    File.dirname(__FILE__)
  end

  def self.env
    'test'
  end
end

class ApplicationController < ActionController::Base

  def runtime_error
    raise "This is a runtime error that we should be emailed about"
  end

  def ar_record_not_found
    #From SuperExceptionNotifier::CustomExceptionMethods
    record_not_found
  end

  def name_error
    raise NameError
  end

  def unknown_controller
    raise ActionController::UnknownController
  end

  def local_request?
    false
  end
  
end

class SpecialErrorThing < RuntimeError
end

class BasicController < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
end

class CustomSilentExceptions < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
  self.exception_notifiable_silent_exceptions = [RuntimeError]
end

class EmptySilentExceptions < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
  self.exception_notifiable_silent_exceptions = []
end

class NilSilentExceptions < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
  self.exception_notifiable_silent_exceptions = nil
end

class DefaultSilentExceptions < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
end

class OldStyle < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
end

class NewStyle < ApplicationController
  include ExceptionNotification::ExceptionNotifiable
  self.exception_notifiable_noisy_environments = ['test']
  self.exception_notifiable_verbose = false
    
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :text => "404", :status => 404
  end

  rescue_from RuntimeError do |exception|
    render :text => "500", :status => 500
  end
end
