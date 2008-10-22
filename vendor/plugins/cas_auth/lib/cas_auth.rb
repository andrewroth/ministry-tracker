require 'cas'
require 'uri'
require 'logger'

module CAS
  # The DummyLogger is a class which might pass through to a real Logger
  # if one is assigned. However, it can gracefully swallow any logging calls
  # if there is now Logger assigned.
  class LoggerWrapper
    def initialize(logger=nil)
      set_logger(logger)
    end
    # Assign the 'real' Logger instance that this dummy instance wraps around.
    def set_logger(logger)
      @logger = logger
    end
    # log using the appropriate method if we have a logger
    # if we dont' have a logger, ignore completely.
    def method_missing(name, *args)
      if @logger && @logger.respond_to?(name)
        @logger.send(name, *args)
      end
    end
  end

  LOGGER = CAS::LoggerWrapper.new
  
  # Allows authentication through a CAS server.
  # The precondition for this filter to work is that you have an
  # authentication infrastructure. As such, this is for the enterprise
  # rather than small shops.
  #
  # To use CAS::Filter for authentication, add something like this to
  # your environment.
  #
  #   CAS::Filter.login_url = "https://cas.company.com/login"
  #   CAS::Filter.validate_url = "https://cas.company.com/proxyValidate"
  #   CAS::Filter.server_name = "yourapplication.server.name"
  #
  # It is of course possible to use different
  # configurations in development, test and production.
  #
  # CAS::Filter is automatically added as a filter for the complete
  # application, but you can remove the filter from a part of the
  # system by adding
  #   skip_before_filter CAS::Filter
  # in a controller.
  #
  # By default CAS::Filter saves the logged in user in session[:casfilteruser] but
  # that name can be changed by setting CAS::Filter.session_username
  # The username is also available from the request by
  #   request.username
  # This wrapping of the request can be disabled by setting CAS::Filter.wrap_request
  # to false.
  #
  # Some CAS situations require proxies to work. This can be set by adding them to
  # CAS::Filter.authorized_proxies.
  #
  class Filter
    @@login_url = "https://localhost/login"
    @@logout_url = nil
    @@validate_url = "https://localhost/proxyValidate"
    @@server_name = "localhost"
    @@renew = false
    @@session_username = :casfilteruser
    @@query_string = {}
    @@fake = nil
    cattr_accessor :query_string
    cattr_accessor :login_url, :validate_url, :service_url, :server_name, :proxy_callback_url, :renew, :wrap_request, :gateway, :session_username
    @@authorized_proxies = []
    cattr_accessor :authorized_proxies


    class <<self
      # Retrieves the current Logger instance
      def logger
        CAS::LOGGER
      end
      def logger=(val)
        CAS::LOGGER.set_logger(val)
      end

      alias :log :logger
      alias :log= :logger=

      def create_logout_url
        if !@@logout_url && @@login_url =~ %r{^(.+?)/[^/]*$}
          @@logout_url = "#{$1}/logout"
        end
        logger.info "Created logout-url: #{@@logout_url}"
      end
      
      def logout_url(ctor)
        create_logout_url unless @@logout_url
        url = redirect_url(ctor,@@logout_url)
        logger.info "Using logout-url #{url}"
        url
      end
      
      def logout_url=(val)
        @@logout_url = val
      end
        
      def fake
        @@fake
      end
      
      def fake=(val)
        if val.nil?
          alias :filter :filter_r
        else
          alias :filter :filter_f
        end
        @@fake = val
      end

      def filter_f(controller)
        logger.debug("entering fake cas filter")
        username = @@fake
        if :failure == @@fake
          return false
        elsif :param == @@fake
          username = controller.params['username']
        elsif Proc === @@fake
          username = @@fake.call(controller)
        end
        logger.debug("our username is: #{username}")
        controller.session[@@session_username] = username
        return true
      end
      
      def filter_r(controller)
        logger.debug("filter of controller: #{controller}")
        receipt = controller.session[:casfilterreceipt]
        logger.info("receipt: #{receipt}")
        valid = false
        if receipt
          valid = validate_receipt(receipt)
          logger.info("valid receipt?: #{valid}")
        else
          reqticket = controller.params["ticket"]
          logger.info("ticket: #{reqticket}")
          if reqticket
            receipt = authenticated_user(reqticket,controller)
            logger.info("new receipt: #{receipt}")
            logger.info("validate_receipt: " + validate_receipt(receipt).to_s)
            if receipt && validate_receipt(receipt)
              controller.session[:casfilterreceipt] = receipt
              controller.session[@@session_username] = receipt.user_name
              valid = true
            end
          else
            did_gateway = controller.session[:casfiltergateway]
            raise CASException, "Can't redirect without login url" if !@@login_url
            if did_gateway
              if controller.session[@@session_username]
                valid = true
              else
                controller.session[:casfiltergateway] = true
              end
            else
              controller.session[:casfiltergateway] = true
            end
          end
        end
        logger.info("will send redirect #{redirect_url(controller)}") if !valid
        controller.send :redirect_to,redirect_url(controller) if !valid
        return valid
      end
      alias :filter :filter_r
    end
      
    private
    def self.validate_receipt(receipt)
        receipt &&
        !(@@renew && !receipt.primary_authentication?) &&
        !(receipt.proxied? && !@@authorized_proxies.include?(receipt.proxying_service))
    end

    def self.authenticated_user(tick, controller)
      pv = ProxyTicketValidator.new
      pv.validate_url = @@validate_url
      pv.service_ticket = tick
      pv.service = service_url(controller)
      pv.renew = @@renew
      pv.proxy_callback_url = @@proxy_callback_url
      receipt = nil
      begin
        receipt = Receipt.new(pv)
      rescue AuthenticationException=>auth
        logger.warn("filter: had an authentication-exception #{auth}")
      end
      receipt
    end
    def self.service_url(controller)
      escapeForRedirect = Regexp.new("[^a-zA-Z0-9]",false, 'N').freeze
      before = @@service_url || guess_service(controller)
      logger.debug("before: #{before}")
      after = URI.escape(before,escapeForRedirect)
      logger.debug("after: #{after}")
      after
    end
    def self.redirect_url(controller,url=@@login_url)
      "#{url}?service=#{service_url(controller)}" + ((@@renew)? "&renew=true":"") + ((@@gateway)? "&gateway=true":"") + ((@@query_string.nil?)? "" : "&"+(@@query_string.collect { |k,v| "#{k}=#{v}"}.join("&")))
    end
    def self.guess_service(controller)
      req = controller.request
      parms = controller.params.dup
      parms.delete("ticket")
      query = (parms.collect {|key, val| "#{key}=#{val}"}).join("&")
      query = "?" + query unless query.empty?
      "#{req.protocol}#{@@server_name}#{req.request_uri.split(/\?/)[0]}#{query}"
    end
  end
end

class ActionController::AbstractRequest
  def username
    session[CAS::Filter.session_username]
  end
end
