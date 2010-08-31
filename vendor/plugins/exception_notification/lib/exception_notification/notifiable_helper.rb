#Copyright (c) 2008-2009 Peter H. Boling of 9thBit LLC
#Released under the MIT license

module ExceptionNotification::NotifiableHelper
  include ExceptionNotification::CustomExceptionClasses
  include ExceptionNotification::CustomExceptionMethods
  include ExceptionNotification::HelpfulHashes
  include ExceptionNotification::GitBlame
  include ExceptionNotification::HooksNotifier

  private

  def get_method_name
    if  /`(.*)'/.match(caller.first)
      return $1
    end
    nil
  end

  def get_exception_data
    deliverer = self.class.exception_data
    return case deliverer
      when nil then {}
      when Symbol then send(deliverer)
      when Proc then deliverer.call(self)
    end
  end

  def verbose_output(exception, status_cd, file_path, send_email, send_web_hooks, request = nil, the_blamed = nil, rejected_sections = nil)
    logger.info("[EXCEPTION] #{exception}")
    logger.info("[EXCEPTION CLASS] #{exception.class}")
    logger.info("[EXCEPTION STATUS_CD] #{status_cd}")
    logger.info("[ERROR LAYOUT] #{self.class.error_layout}") if self.class.respond_to?(:error_layout)
    logger.info("[ERROR VIEW PATH] #{ExceptionNotification::Notifier.config[:view_path]}") if !ExceptionNotification::Notifier.nil? && !ExceptionNotification::Notifier.config[:view_path].nil?
    logger.info("[ERROR FILE PATH] #{file_path.inspect}")
    logger.info("[ERROR EMAIL] #{send_email ? "YES" : "NO"}")
    logger.info("[ERROR WEB HOOKS] #{send_web_hooks ? "YES" : "NO"}")
    logger.info("[THE BLAMED] #{the_blamed}") unless the_blamed.blank?
    logger.info("[SECTIONS] #{ExceptionNotification::Notifier.sections_for_email(rejected_sections, request).inspect}")
    req = request ? " for request_uri=#{request.request_uri}" : ""
    logger.error("render_error(#{status_cd}, #{self.class.http_status_codes[status_cd]}) invoked#{req}") if self.class.respond_to?(:http_status_codes)
  end

  def perform_exception_notify_mailing(exception, data, request = nil, the_blamed = nil, verbose = false, rejected_sections = nil)
    if ExceptionNotification::Notifier.config[:exception_recipients].blank?
      logger.info("[EMAIL NOTIFICATION] ExceptionNotification::Notifier.config[:exception_recipients] is blank, notification cancelled!") if verbose
    else
      class_name = self.respond_to?(:controller_name) ? self.controller_name : self.to_s
      method_name = self.respond_to?(:action_name) ? self.action_name : get_method_name
      ExceptionNotification::Notifier.deliver_exception_notification(exception, class_name, method_name,
        request, data, the_blamed, rejected_sections)
      logger.info("[EMAIL NOTIFICATION] Sent") if verbose
    end
  end

  def should_email_on_exception?(exception, status_cd = nil, verbose = false)
    environment_is_noisy? && notification_level_sends_email? && !ExceptionNotification::Notifier.config[:exception_recipients].blank? && should_notify_on_exception?(exception, status_cd, verbose)
  end

  def should_web_hook_on_exception?(exception, status_cd = nil, verbose = false)
    environment_is_noisy? && notification_level_sends_web_hooks? && !ExceptionNotification::Notifier.config[:web_hooks].blank? && should_notify_on_exception?(exception, status_cd, verbose)
  end

  # Relies on the base class to define be_silent_for_exception?
  def should_notify_on_exception?(exception, status_cd = nil, verbose = false)
    # don't notify (email or web hooks) on exceptions raised locally
    verbose && ExceptionNotification::Notifier.config[:skip_local_notification] && is_local? ?
      logger.info("[NOTIFY LOCALLY] NO") :
      nil
    return false if ExceptionNotification::Notifier.config[:skip_local_notification] && is_local?
    # don't notify (email or web hooks) exceptions raised that match ExceptionNotifiable.notifiable_silent_exceptions
    return false if self.be_silent_for_exception?(exception)
    return true if ExceptionNotification::Notifier.config[:notify_error_classes].include?(exception.class)
    return true if !status_cd.nil? && ExceptionNotification::Notifier.config[:notify_error_codes].include?(status_cd)
    return ExceptionNotification::Notifier.config[:notify_other_errors]
  end
end
