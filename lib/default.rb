require 'xsd/qname'

# {sso.provider.tntware.com}SsoUser
#   userID - SOAP::SOAPString
#   email - SOAP::SOAPString
#   firstName - SOAP::SOAPString
#   lastName - SOAP::SOAPString
#   proxyServiceNames - ArrayOfString
class SsoUser
  attr_accessor :userID
  attr_accessor :email
  attr_accessor :firstName
  attr_accessor :lastName
  attr_accessor :proxyServiceNames

  def initialize(userID = nil, email = nil, firstName = nil, lastName = nil, proxyServiceNames = nil)
    @userID = userID
    @email = email
    @firstName = firstName
    @lastName = lastName
    @proxyServiceNames = proxyServiceNames
  end
end

# {sso.provider.tntware.com}ArrayOfString
class ArrayOfString < ::Array
end

# {sso.provider.tntware.com}GetClientLoginUrlBase
class GetClientLoginUrlBase
  def initialize
  end
end

# {sso.provider.tntware.com}GetClientLoginUrlBaseResponse
#   getClientLoginUrlBaseResult - SOAP::SOAPString
class GetClientLoginUrlBaseResponse
  attr_accessor :getClientLoginUrlBaseResult

  def initialize(getClientLoginUrlBaseResult = nil)
    @getClientLoginUrlBaseResult = getClientLoginUrlBaseResult
  end
end

# {sso.provider.tntware.com}GetServiceTicketParamName
class GetServiceTicketParamName
  def initialize
  end
end

# {sso.provider.tntware.com}GetServiceTicketParamNameResponse
#   getServiceTicketParamNameResult - SOAP::SOAPString
class GetServiceTicketParamNameResponse
  attr_accessor :getServiceTicketParamNameResult

  def initialize(getServiceTicketParamNameResult = nil)
    @getServiceTicketParamNameResult = getServiceTicketParamNameResult
  end
end

# {sso.provider.tntware.com}GetLogoutServiceTicketPrefix
class GetLogoutServiceTicketPrefix
  def initialize
  end
end

# {sso.provider.tntware.com}GetLogoutServiceTicketPrefixResponse
#   getLogoutServiceTicketPrefixResult - SOAP::SOAPString
class GetLogoutServiceTicketPrefixResponse
  attr_accessor :getLogoutServiceTicketPrefixResult

  def initialize(getLogoutServiceTicketPrefixResult = nil)
    @getLogoutServiceTicketPrefixResult = getLogoutServiceTicketPrefixResult
  end
end

# {sso.provider.tntware.com}GetSsoUserFromServiceTicket
#   serviceName - SOAP::SOAPString
#   serviceTicket - SOAP::SOAPString
class GetSsoUserFromServiceTicket
  attr_accessor :serviceName
  attr_accessor :serviceTicket

  def initialize(serviceName = nil, serviceTicket = nil)
    @serviceName = serviceName
    @serviceTicket = serviceTicket
  end
end

# {sso.provider.tntware.com}GetSsoUserFromServiceTicketResponse
#   getSsoUserFromServiceTicketResult - SsoUser
class GetSsoUserFromServiceTicketResponse
  attr_accessor :getSsoUserFromServiceTicketResult

  def initialize(getSsoUserFromServiceTicketResult = nil)
    @getSsoUserFromServiceTicketResult = getSsoUserFromServiceTicketResult
  end
end

# {sso.provider.tntware.com}GetServiceTicketFromUserNamePassword
#   serviceName - SOAP::SOAPString
#   userName - SOAP::SOAPString
#   password - SOAP::SOAPString
#   clientIpAddress - SOAP::SOAPString
class GetServiceTicketFromUserNamePassword
  attr_accessor :serviceName
  attr_accessor :userName
  attr_accessor :password
  attr_accessor :clientIpAddress

  def initialize(serviceName = nil, userName = nil, password = nil, clientIpAddress = nil)
    @serviceName = serviceName
    @userName = userName
    @password = password
    @clientIpAddress = clientIpAddress
  end
end

# {sso.provider.tntware.com}GetServiceTicketFromUserNamePasswordResponse
#   getServiceTicketFromUserNamePasswordResult - SOAP::SOAPString
class GetServiceTicketFromUserNamePasswordResponse
  attr_accessor :getServiceTicketFromUserNamePasswordResult

  def initialize(getServiceTicketFromUserNamePasswordResult = nil)
    @getServiceTicketFromUserNamePasswordResult = getServiceTicketFromUserNamePasswordResult
  end
end
