require 'net/https'
require 'rexml/document'

module CAS
  class CASException < Exception
  end
  class AuthenticationException < CASException
  end
  class ValidationException < CASException
  end

  class Receipt
    attr_accessor :validate_url, :pgt_iou, :primary_authentication, :proxy_callback_url, :proxy_list, :user_name,
                  :first_name, :last_name, :guid

    def primary_authentication?
      primary_authentication
    end

    def initialize(ptv)
      if !ptv.successful_authentication?
        begin
          ptv.validate
        rescue ValidationException=>vald
          raise AuthenticationException, "Unable to validate ProxyTicketValidator [#{ptv}] [#{vald}]"
        end
        raise AuthenticationException, "Unable to validate ProxyTicketValidator because of no success with validation[#{ptv}]" unless ptv.successful_authentication?
      end
      self.validate_url = ptv.validate_url
      self.pgt_iou = ptv.pgt_iou
      self.user_name = ptv.user
      self.first_name = ptv.first_name
      self.last_name = ptv.last_name
      self.guid = ptv.guid
      self.proxy_callback_url = ptv.proxy_callback_url
      self.proxy_list = ptv.proxy_list
      self.primary_authentication = ptv.renewed?
      raise AuthenticationException, "Validation of [#{ptv}] did not result in an internally consistent Receipt" unless validate
    end

    def proxied?
      !proxy_list.empty?
    end

    def proxying_service
      proxy_list.first
    end

    def to_s
      "[#{super} - userName=[#{user_name}] calidateUrl=[#{validate_url}] proxyCallbackUrl=[#{proxy_callback_url}] pgtIou=[#{pgt_iou}] proxyList=[#{proxy_list}]"
    end

    def validate
      user_name &&
        validate_url &&
        proxy_list &&
        !(primary_authentication? && !proxy_list.empty?) # May not be both primary authenitication and proxied.
    end
  end

  class ServiceTicketValidator
    attr_accessor :validate_url, :proxy_callback_url, :renew, :service_ticket, :service
    attr_reader   :pgt_iou, :user, :error_code, :error_message, :entire_response, :successful_authentication,
                  :first_name, :last_name, :guid

    def renewed?
      renew
    end

    def successful_authentication?
      successful_authentication
    end

    def validate
      raise ValidationException, "must set validation URL and ticket" if validate_url.nil? || service_ticket.nil?
      clear!
      @attempted_authentication = true
      url_building = "#{validate_url}#{(url_building =~ /\?/)?'&':'?'}service=#{service}&ticket=#{service_ticket}"
      url_building += "&pgtUrl=#{proxy_callback_url}" if proxy_callback_url
      url_building += "&renew=true" if renew
      @@entire_response = ServiceTicketValidator.retrieve url_building
      parse @@entire_response
    end

    def clear!
      @user = @pgt_iou = @error_message = nil
      @successful_authentication = @attempted_authentication = false
    end

    def to_s
      "[#{super} - validateUrl=[#{validate_url}] proxyCallbackUrl=[#{proxy_callback_url}] ticket=[#{service_ticket}] service=[#{service} pgtIou=[#{pgt_iou}] user=[#{user}] errorCode=[#{error_message}] errorMessage=[#{error_message}] renew=[#{renew}] entireResponse=[#{entire_response}]]"
    end

    def self.retrieve(uri_str)
      prs = URI.parse(uri_str)
      https = Net::HTTP.new(prs.host,443)
      https.use_ssl=true
      https.start { |conn|
        conn.get("#{prs.path}?#{prs.query}").body.strip
      }
    end

    protected
    def parse_successful(elm)
#      puts "successful"
      @user = elm.elements["cas:user"] && elm.elements["cas:user"].text.strip
      @attributes = elm.elements["cas:attributes"]
      @first_name = @attributes.elements["firstName"].text.strip
      @last_name = @attributes.elements["lastName"].text.strip
      @guid = @attributes.elements["ssoGuid"].text.strip
#      puts "user: #{@user}"
      @pgt_iou = elm.elements["cas:proxyGrantingTicket"] && elm.elements["cas:proxyGrantingTicket"].text.strip
#      puts "pgt_iou: #{@pgt_iou}"
      @successful_authentication = true
    end

    def parse_unsuccessful(elm)
#      puts "unsuccessful"
      @error_message = elm.text.strip
      @error_code = elm.attributes["code"].strip
      @successful_authentication = false
    end

    def parse(str)
      # raise "parsing... #{str}"
      doc = REXML::Document.new str
      resp = doc.elements["cas:serviceResponse"].elements[1]
#      puts "resp... #{resp.name}"
      if resp.name == "authenticationSuccess"
        parse_successful(resp)
      else
        parse_unsuccessful(resp)
      end
    end
  end

  class ProxyTicketValidator < ServiceTicketValidator
    attr_reader :proxy_list

    def initialize
      super
      @proxy_list = []
    end

    def clear!
      super
      @proxy_list = []
    end

    protected
    def parse_successful(elm)
      super(elm)
#      puts "proxy_successful"
      proxies = elm.elements["cas:proxies"]
      if proxies
        proxies.elements.each("cas:proxy") { |prox|
          @proxy_list ||= []
          @proxy_list << prox.text.strip
        }
      end
    end
  end
end
