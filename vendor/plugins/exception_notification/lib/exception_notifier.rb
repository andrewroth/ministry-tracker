require 'pathname'

class ExceptionNotifier < ActionMailer::Base

  @@config = {
    # If left empty web hooks will not be engaged
    :web_hooks                => [],
    :app_name                 => "[MYAPP]",
    :version                  => "0.0.0",
    :sender_address           => %("#{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} Error" <super.exception.notifier@example.com>),
    :exception_recipients     => [],
    # Customize the subject line
    :subject_prepend          => "[#{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} ERROR] ",
    :subject_append           => nil,
    # Include which sections of the exception email? 
    :sections                 => %w(request session environment backtrace),
    # Only use this gem to render, never email
    :render_only              => false,
    :skip_local_notification  => true,
    :view_path                => nil,
    #Error Notification will be sent if the HTTP response code for the error matches one of the following error codes
    :send_email_error_codes   => %W( 405 500 503 ),
    #Error Notification will be sent if the error class matches one of the following error error classes
    :send_email_error_classes => %W( ),
    :send_email_other_errors  => true,
    :git_repo_path            => nil,
    :template_root            => "#{File.dirname(__FILE__)}/../views"
  }

  cattr_accessor :config

  def self.configure_exception_notifier(&block)
    yield @@config
  end
  
  self.template_root = config[:template_root]

  def self.reloadable?() false end

  # What is the path of the file we will render to the user?
  def self.get_view_path(status_cd)
    if File.exist?("#{RAILS_ROOT}/public/#{status_cd}.html")
      "#{RAILS_ROOT}/public/#{status_cd}.html"
    elsif !config[:view_path].nil? && File.exist?("#{RAILS_ROOT}/#{config[:view_path]}/#{status_cd}.html")
      "#{RAILS_ROOT}/#{config[:view_path]}/#{status_cd}.html"
    elsif File.exist?("#{File.dirname(__FILE__)}/../rails/app/views/exception_notifiable/#{status_cd}.html")
      #ExceptionNotifierHelper::COMPAT_MODE ? "#{File.dirname(__FILE__)}/../rails/app/views/exception_notifiable/#{status_cd}.html" : "#{status_cd}.html"
      "#{File.dirname(__FILE__)}/../rails/app/views/exception_notifiable/#{status_cd}.html"
    else
      #ExceptionNotifierHelper::COMPAT_MODE ? "#{File.dirname(__FILE__)}/../rails/app/views/exception_notifiable/500.html" : "500.html"
      "#{File.dirname(__FILE__)}/../rails/app/views/exception_notifiable/500.html"
    end
  end

  def exception_notification(exception, controller = nil, request = nil, data={}, the_blamed=nil)
    body_hash = error_environment_data_hash(exception, controller, request, data, the_blamed)
    #Prefer to have custom, potentially HTML email templates available
    #content_type  "text/plain"
    recipients    config[:exception_recipients]
    from          config[:sender_address]

    request.session.inspect unless request.nil? # Ensure session data is loaded (Rails 2.3 lazy-loading)
    
    subject       "#{config[:subject_prepend]}#{body_hash[:location]} (#{exception.class}) #{exception.message.inspect}#{config[:subject_append]}"
    body          body_hash
  end
  
  def background_exception_notification(exception, data = {}, the_blamed = nil)
    exception_notification(exception, nil, nil, data, the_blamed)
  end

  private

    def error_environment_data_hash(exception, controller = nil, request = nil, data={}, the_blamed=nil)
      data.merge!({
        :exception => exception,
        :backtrace => sanitize_backtrace(exception.backtrace),
        :rails_root => rails_root,
        :data => data,
        :the_blamed => the_blamed
      })

      if controller && request
        data.merge!({
          :location => "#{controller.controller_name}##{controller.action_name}",
          :controller => controller,
          :request => request,
          :host => (request.env['HTTP_X_REAL_IP'] || request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"]),
          :sections => config[:sections]
        })
      else
        # TODO: with refactoring, the environment section could show useful ENV data even without a request
        data.merge!({
          :location => sanitize_backtrace([exception.backtrace.first]).first,
          :sections => config[:sections] - %w(request session environment)
        })
      end
      return data
    end

    def sanitize_backtrace(trace)
      re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
      trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
    end

    def rails_root
      @rails_root ||= Pathname.new(RAILS_ROOT).cleanpath.to_s
    end

end
