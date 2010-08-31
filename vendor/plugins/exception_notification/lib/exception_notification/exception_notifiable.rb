# This module needs to be included in ApplicationController in order to work.

require 'ipaddr'

module ExceptionNotification::ExceptionNotifiable
  include ExceptionNotification::NotifiableHelper

  def self.included(base)
    base.extend ClassMethods

    # Sets up an alias chain to catch exceptions when Rails does
    #This is what makes it all work with Hoptoad or other exception catchers.
#    base.send(:alias_method, :rescue_action_locally_without_sen_handler, :rescue_action_locally)
#    base.send(:alias_method, :rescue_action_locally, :rescue_action_locally_with_sen_handler)

#Alias method chaining doesn't work here because it would trigger a double render error.
    # Sets up an alias chain to catch exceptions when Rails does
    #This is what makes it all work with Hoptoad or other exception catchers.
#    base.send(:alias_method, :rescue_action_in_public_without_exception_notifiable, :rescue_action_in_public)
#    base.send(:alias_method, :rescue_action_in_public, :rescue_action_in_public_with_exception_notifiable)

    # Adds the following class attributes to the classes that include ExceptionNotifiable
    #  HTTP status codes and what their 'English' status message is
    base.cattr_accessor :http_status_codes
    base.http_status_codes = HTTP_STATUS_CODES
    # error_layout:
    #   can be defined at controller level to the name of the desired error layout,
    #   or set to true to render the controller's own default layout,
    #   or set to false to render errors with no layout
    base.cattr_accessor :error_layout
    base.error_layout = nil
    # Rails error classes to rescue and how to rescue them (which error code to use)
    base.cattr_accessor :error_class_status_codes
    base.error_class_status_codes = self.codes_for_error_classes
    # Verbosity of the gem
    base.cattr_accessor :exception_notifiable_verbose
    base.exception_notifiable_verbose = false
    # Do Not Ever send error notification emails for these Error Classes
    base.cattr_accessor :exception_notifiable_silent_exceptions
    base.exception_notifiable_silent_exceptions = SILENT_EXCEPTIONS
    # Notification Level
    base.cattr_accessor :exception_notifiable_notification_level
    base.exception_notifiable_notification_level = [:render, :email, :web_hooks]
    # Since there is no concept of locality from a request here allow user to explicitly define which env's are noisy (send notifications)
    base.cattr_accessor :exception_notifiable_noisy_environments
    base.exception_notifiable_noisy_environments = ["production"]

    base.cattr_accessor :exception_notifiable_pass_through
    base.exception_notifiable_pass_through = false
  end

  module ClassMethods
    include ExceptionNotification::DeprecatedMethods

    # specifies ip addresses that should be handled as though local
    def consider_local(*args)
      local_addresses.concat(args.flatten.map { |a| IPAddr.new(a) })
    end

    def local_addresses
      addresses = read_inheritable_attribute(:local_addresses)
      unless addresses
        addresses = [IPAddr.new("127.0.0.1")]
        write_inheritable_attribute(:local_addresses, addresses)
      end
      addresses
    end

    # set the exception_data deliverer OR retrieve the exception_data
    def exception_data(deliverer = nil)
      if deliverer
        write_inheritable_attribute(:exception_data, deliverer)
      else
        read_inheritable_attribute(:exception_data)
      end
    end

    def be_silent_for_exception?(exception)
      self.exception_notifiable_silent_exceptions.respond_to?(:any?) && self.exception_notifiable_silent_exceptions.any? {|klass| klass === exception }
    end

  end

  def be_silent_for_exception?(exception)
    self.class.be_silent_for_exception?(exception)
  end

  private

    def environment_is_noisy?
      self.class.exception_notifiable_noisy_environments.include?(Rails.env)
    end
  
    def notification_level_sends_email?
      self.class.exception_notifiable_notification_level.include?(:email)
    end

    def notification_level_sends_web_hooks?
      self.class.exception_notifiable_notification_level.include?(:web_hooks)
    end

    def notification_level_renders?
      self.class.exception_notifiable_notification_level.include?(:render)
    end

    # overrides Rails' local_request? method to also check any ip
    # addresses specified through consider_local.
    def local_request?
      remote = IPAddr.new(request.remote_ip)
      !self.class.local_addresses.detect { |addr| addr.include?(remote) }.nil?
    end

    #No Request present
    # When the action being executed has its own local error handling (rescue)
    # Or when the error occurs somewhere without a subsequent render (eg. method calls in console)
    def rescue_with_handler(exception)
      to_return = super
      if to_return
        verbose = self.class.exception_notifiable_verbose && respond_to?(:logger) && !logger.nil?
        logger.info("[RESCUE STYLE] rescue_with_handler") if verbose
        data = get_exception_data
        status_code = status_code_for_exception(exception)
        #We only send email if it has been configured in environment
        send_email = should_email_on_exception?(exception, status_code, verbose)
        #We only send web hooks if they've been configured in environment
        send_web_hooks = should_web_hook_on_exception?(exception, status_code, verbose)
        the_blamed = ExceptionNotification::Notifier.config[:git_repo_path].nil? ? nil : lay_blame(exception)
        rejected_sections = %w(request session)
        # Debugging output
        verbose_output(exception, status_code, "rescued by handler", send_email, send_web_hooks, nil, the_blamed, rejected_sections) if verbose
        # Send the exception notification email
        perform_exception_notify_mailing(exception, data, nil, the_blamed, verbose, rejected_sections) if send_email
        # Send Web Hook requests
        ExceptionNotification::HooksNotifier.deliver_exception_to_web_hooks(ExceptionNotification::Notifier.config, exception, self, request, data, the_blamed) if send_web_hooks
        pass_it_on(exception, ENV)
      end
      to_return
    end

    # Overrides the rescue_action method in ActionController::Base, but does not inhibit
    # any custom processing that is defined with Rails 2's exception helpers.
    # When the action being executed is letting SEN handle the exception completely
    def rescue_action_in_public(exception)
      # If the error class is NOT listed in the rails_error_class hash then we get a generic 500 error:
      # OTW if the error class is listed, but has a blank code or the code is == '200' then we get a custom error layout rendered
      # OTW the error class is listed!
      verbose = self.class.exception_notifiable_verbose && respond_to?(:logger) && !logger.nil?
      logger.info("[RESCUE STYLE] rescue_action_in_public") if verbose
      status_code = status_code_for_exception(exception)
      if status_code == '200'
        notify_and_render_error_template(status_code, request, exception, ExceptionNotification::Notifier.get_view_path_for_class(exception, verbose), verbose)
      else
        notify_and_render_error_template(status_code, request, exception, ExceptionNotification::Notifier.get_view_path_for_status_code(status_code, verbose), verbose)
      end
      pass_it_on(exception, ENV, request, params, session)
    end

    def notify_and_render_error_template(status_cd, request, exception, file_path, verbose = false)
      status = self.class.http_status_codes[status_cd] ? status_cd + " " + self.class.http_status_codes[status_cd] : status_cd
      data = get_exception_data
      #We only send email if it has been configured in environment
      send_email = should_email_on_exception?(exception, status_cd, verbose)
      #We only send web hooks if they've been configured in environment
      send_web_hooks = should_web_hook_on_exception?(exception, status_cd, verbose)
      the_blamed = ExceptionNotification::Notifier.config[:git_repo_path].nil? ? nil : lay_blame(exception)
      rejected_sections = request.nil? ? %w(request session) : []
      # Debugging output
      verbose_output(exception, status_cd, file_path, send_email, send_web_hooks, request, the_blamed, rejected_sections) if verbose
      #TODO: is _rescue_action something from rails 3?
      #if !(self.controller_name == 'application' && self.action_name == '_rescue_action')
      # Send the exception notification email
      perform_exception_notify_mailing(exception, data, request, the_blamed, verbose, rejected_sections) if send_email
      # Send Web Hook requests
      ExceptionNotification::HooksNotifier.deliver_exception_to_web_hooks(ExceptionNotification::Notifier.config, exception, self, request, data, the_blamed) if send_web_hooks

      # We put the render call after the deliver call to ensure that, if the
      # deliver raises an exception, we don't call render twice.
      # Render the error page to the end user
      render_error_template(file_path, status)
    end

    # some integration with hoptoad or other exception handler
    # is done by tha alias method chain on:
    #    rescue_action_locally
    def pass_it_on(exception, env, request = {:params => {}}, params = {}, session = {})
      begin
        case self.class.exception_notifiable_pass_through
          when :hoptoad then
            HoptoadNotifier.notify(exception, sen_hoptoad_request_data(env, request, params, session))
            logger.info("[PASS-IT-ON] HOPTOAD NOTIFIED") if verbose
          else
            logger.info("[PASS-IT-ON] NO") if verbose
            #Do Nothing
        end
      rescue
        #Do Nothing
        logger.info("[PASS-IT-ON] FAILED") if verbose
      end
    end

    def sen_hoptoad_request_data(env, request, params, session)
      { :parameters       => sen_hoptoad_filter_if_filtering(params.to_hash),
        :session_data     => sen_hoptoad_session_data(session),
        :controller       => params[:controller],
        :action           => params[:action],
        :url              => sen_hoptoad_request_url(request),
        :cgi_data         => request.respond_to?(:env) ? sen_hoptoad_filter_if_filtering(request.env) : nil,
        :environment_vars => sen_hoptoad_filter_if_filtering(env),
        :request          => request }
    end

    def sen_hoptoad_filter_if_filtering(hash)
      if respond_to?(:filter_parameters)
        filter_parameters(hash) rescue hash
      else
        hash
      end
    end

    def sen_hoptoad_session_data(session)
      if session.respond_to?(:to_hash)
        session.to_hash
      elsif session.respond_to?(:data)
        session.data
      end
    end

    def sen_hoptoad_request_url(request)
      if request.respond_to?(:protocol)
        url = "#{request.protocol}#{request.host}"

        unless [80, 443].include?(request.port)
          url << ":#{request.port}"
        end

        url << request.request_uri
        url
      end
    end

    def is_local?
      (consider_all_requests_local || local_request?)
    end

    def status_code_for_exception(exception)
      self.class.error_class_status_codes[exception.class].nil? ?
              '500' :
              self.class.error_class_status_codes[exception.class].blank? ?
                      '200' :
                      self.class.error_class_status_codes[exception.class]
    end

    def render_error_template(file, status)
      respond_to do |type|
        type.html { render :file => file,
                            :layout => self.class.error_layout,
                            :status => status }
        type.all  { render :nothing => true,
                            :status => status}
      end
    end

end
