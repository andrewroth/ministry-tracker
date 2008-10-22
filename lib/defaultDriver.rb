require 'soap/rpc/driver'
require 'default.rb'
require 'defaultMappingRegistry.rb'

class TntWareSSOProviderSoap < ::SOAP::RPC::Driver
  DefaultEndpointUrl = "https://dataserver.tntware.com/dataserver/test/gcxauthentication/gcxauthenticationservice.asmx"

  Methods = [
    [ "sso.provider.tntware.com/GetClientLoginUrlBase",
      "getClientLoginUrlBase",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetClientLoginUrlBase"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetClientLoginUrlBaseResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ],
    [ "sso.provider.tntware.com/GetServiceTicketParamName",
      "getServiceTicketParamName",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetServiceTicketParamName"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetServiceTicketParamNameResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ],
    [ "sso.provider.tntware.com/GetLogoutServiceTicketPrefix",
      "getLogoutServiceTicketPrefix",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetLogoutServiceTicketPrefix"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetLogoutServiceTicketPrefixResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ],
    [ "sso.provider.tntware.com/GetSsoUserFromServiceTicket",
      "getSsoUserFromServiceTicket",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetSsoUserFromServiceTicket"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetSsoUserFromServiceTicketResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ],
    [ "sso.provider.tntware.com/GetServiceTicketFromUserNamePassword",
      "getServiceTicketFromUserNamePassword",
      [ ["in", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetServiceTicketFromUserNamePassword"]],
        ["out", "parameters", ["::SOAP::SOAPElement", "sso.provider.tntware.com", "GetServiceTicketFromUserNamePasswordResponse"]] ],
      { :request_style =>  :document, :request_use =>  :literal,
        :response_style => :document, :response_use => :literal,
        :faults => {} }
    ]
  ]

  def initialize(endpoint_url = nil)
    endpoint_url ||= DefaultEndpointUrl
    super(endpoint_url, nil)
    self.mapping_registry = DefaultMappingRegistry::EncodedRegistry
    self.literal_mapping_registry = DefaultMappingRegistry::LiteralRegistry
    init_methods
  end

private

  def init_methods
    Methods.each do |definitions|
      opt = definitions.last
      if opt[:request_style] == :document
        add_document_operation(*definitions)
      else
        add_rpc_operation(*definitions)
        qname = definitions[0]
        name = definitions[2]
        if qname.name != name and qname.name.capitalize == name.capitalize
          ::SOAP::Mapping.define_singleton_method(self, qname.name) do |*arg|
            __send__(name, *arg)
          end
        end
      end
    end
  end
end

