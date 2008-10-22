require 'soap/mapping'
require 'default.rb'

module DefaultMappingRegistry
  EncodedRegistry = ::SOAP::Mapping::EncodedRegistry.new
  LiteralRegistry = ::SOAP::Mapping::LiteralRegistry.new
  NsSsoProviderTntwareCom = "sso.provider.tntware.com"

  EncodedRegistry.register(
    :class => SsoUser,
    :schema_type => XSD::QName.new(NsSsoProviderTntwareCom, "SsoUser"),
    :schema_element => [
      ["userID", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "UserID")], [0, 1]],
      ["email", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "Email")], [0, 1]],
      ["firstName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "FirstName")], [0, 1]],
      ["lastName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "LastName")], [0, 1]],
      ["proxyServiceNames", ["ArrayOfString", XSD::QName.new(NsSsoProviderTntwareCom, "ProxyServiceNames")], [0, 1]]
    ]
  )

  EncodedRegistry.register(
    :class => ArrayOfString,
    :schema_type => XSD::QName.new(NsSsoProviderTntwareCom, "ArrayOfString"),
    :schema_element => [
      ["string", "SOAP::SOAPString[]", [0, nil]]
    ]
  )

  LiteralRegistry.register(
    :class => SsoUser,
    :schema_type => XSD::QName.new(NsSsoProviderTntwareCom, "SsoUser"),
    :schema_element => [
      ["userID", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "UserID")], [0, 1]],
      ["email", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "Email")], [0, 1]],
      ["firstName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "FirstName")], [0, 1]],
      ["lastName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "LastName")], [0, 1]],
      ["proxyServiceNames", ["ArrayOfString", XSD::QName.new(NsSsoProviderTntwareCom, "ProxyServiceNames")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => ArrayOfString,
    :schema_type => XSD::QName.new(NsSsoProviderTntwareCom, "ArrayOfString"),
    :schema_element => [
      ["string", "SOAP::SOAPString[]", [0, nil]]
    ]
  )

  LiteralRegistry.register(
    :class => GetClientLoginUrlBase,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetClientLoginUrlBase"),
    :schema_element => []
  )

  LiteralRegistry.register(
    :class => GetClientLoginUrlBaseResponse,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetClientLoginUrlBaseResponse"),
    :schema_element => [
      ["getClientLoginUrlBaseResult", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "GetClientLoginUrlBaseResult")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => GetServiceTicketParamName,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketParamName"),
    :schema_element => []
  )

  LiteralRegistry.register(
    :class => GetServiceTicketParamNameResponse,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketParamNameResponse"),
    :schema_element => [
      ["getServiceTicketParamNameResult", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketParamNameResult")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => GetLogoutServiceTicketPrefix,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetLogoutServiceTicketPrefix"),
    :schema_element => []
  )

  LiteralRegistry.register(
    :class => GetLogoutServiceTicketPrefixResponse,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetLogoutServiceTicketPrefixResponse"),
    :schema_element => [
      ["getLogoutServiceTicketPrefixResult", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "GetLogoutServiceTicketPrefixResult")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => GetSsoUserFromServiceTicket,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetSsoUserFromServiceTicket"),
    :schema_element => [
      ["serviceName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "ServiceName")], [0, 1]],
      ["serviceTicket", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "ServiceTicket")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => GetSsoUserFromServiceTicketResponse,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetSsoUserFromServiceTicketResponse"),
    :schema_element => [
      ["getSsoUserFromServiceTicketResult", ["SsoUser", XSD::QName.new(NsSsoProviderTntwareCom, "GetSsoUserFromServiceTicketResult")]]
    ]
  )

  LiteralRegistry.register(
    :class => GetServiceTicketFromUserNamePassword,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketFromUserNamePassword"),
    :schema_element => [
      ["serviceName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "ServiceName")], [0, 1]],
      ["userName", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "UserName")], [0, 1]],
      ["password", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "Password")], [0, 1]],
      ["clientIpAddress", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "ClientIpAddress")], [0, 1]]
    ]
  )

  LiteralRegistry.register(
    :class => GetServiceTicketFromUserNamePasswordResponse,
    :schema_name => XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketFromUserNamePasswordResponse"),
    :schema_element => [
      ["getServiceTicketFromUserNamePasswordResult", ["SOAP::SOAPString", XSD::QName.new(NsSsoProviderTntwareCom, "GetServiceTicketFromUserNamePasswordResult")], [0, 1]]
    ]
  )
end
