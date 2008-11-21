#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'defaultDriver.rb'

endpoint_url = ARGV.shift
obj = TntWareSSOProviderSoap.new(endpoint_url)

# run ruby with -d to see SOAP wiredumps.
obj.wiredump_dev = STDERR if $DEBUG

# SYNOPSIS
#   GetClientLoginUrlBase(parameters)
#
# ARGS
#   parameters      GetClientLoginUrlBase - {sso.provider.tntware.com}GetClientLoginUrlBase
#
# RETURNS
#   parameters      GetClientLoginUrlBaseResponse - {sso.provider.tntware.com}GetClientLoginUrlBaseResponse
#
parameters = nil
puts obj.getClientLoginUrlBase(parameters)

# SYNOPSIS
#   GetServiceTicketParamName(parameters)
#
# ARGS
#   parameters      GetServiceTicketParamName - {sso.provider.tntware.com}GetServiceTicketParamName
#
# RETURNS
#   parameters      GetServiceTicketParamNameResponse - {sso.provider.tntware.com}GetServiceTicketParamNameResponse
#
parameters = nil
puts obj.getServiceTicketParamName(parameters)

# SYNOPSIS
#   GetLogoutServiceTicketPrefix(parameters)
#
# ARGS
#   parameters      GetLogoutServiceTicketPrefix - {sso.provider.tntware.com}GetLogoutServiceTicketPrefix
#
# RETURNS
#   parameters      GetLogoutServiceTicketPrefixResponse - {sso.provider.tntware.com}GetLogoutServiceTicketPrefixResponse
#
parameters = nil
puts obj.getLogoutServiceTicketPrefix(parameters)

# SYNOPSIS
#   GetSsoUserFromServiceTicket(parameters)
#
# ARGS
#   parameters      GetSsoUserFromServiceTicket - {sso.provider.tntware.com}GetSsoUserFromServiceTicket
#
# RETURNS
#   parameters      GetSsoUserFromServiceTicketResponse - {sso.provider.tntware.com}GetSsoUserFromServiceTicketResponse
#
parameters = nil
puts obj.getSsoUserFromServiceTicket(parameters)

# SYNOPSIS
#   GetServiceTicketFromUserNamePassword(parameters)
#
# ARGS
#   parameters      GetServiceTicketFromUserNamePassword - {sso.provider.tntware.com}GetServiceTicketFromUserNamePassword
#
# RETURNS
#   parameters      GetServiceTicketFromUserNamePasswordResponse - {sso.provider.tntware.com}GetServiceTicketFromUserNamePasswordResponse
#
parameters = nil
puts obj.getServiceTicketFromUserNamePassword(parameters)


endpoint_url = ARGV.shift
obj = TntWareSSOProviderSoap.new(endpoint_url)

# run ruby with -d to see SOAP wiredumps.
obj.wiredump_dev = STDERR if $DEBUG

# SYNOPSIS
#   GetClientLoginUrlBase(parameters)
#
# ARGS
#   parameters      GetClientLoginUrlBase - {sso.provider.tntware.com}GetClientLoginUrlBase
#
# RETURNS
#   parameters      GetClientLoginUrlBaseResponse - {sso.provider.tntware.com}GetClientLoginUrlBaseResponse
#
parameters = nil
puts obj.getClientLoginUrlBase(parameters)

# SYNOPSIS
#   GetServiceTicketParamName(parameters)
#
# ARGS
#   parameters      GetServiceTicketParamName - {sso.provider.tntware.com}GetServiceTicketParamName
#
# RETURNS
#   parameters      GetServiceTicketParamNameResponse - {sso.provider.tntware.com}GetServiceTicketParamNameResponse
#
parameters = nil
puts obj.getServiceTicketParamName(parameters)

# SYNOPSIS
#   GetLogoutServiceTicketPrefix(parameters)
#
# ARGS
#   parameters      GetLogoutServiceTicketPrefix - {sso.provider.tntware.com}GetLogoutServiceTicketPrefix
#
# RETURNS
#   parameters      GetLogoutServiceTicketPrefixResponse - {sso.provider.tntware.com}GetLogoutServiceTicketPrefixResponse
#
parameters = nil
puts obj.getLogoutServiceTicketPrefix(parameters)

# SYNOPSIS
#   GetSsoUserFromServiceTicket(parameters)
#
# ARGS
#   parameters      GetSsoUserFromServiceTicket - {sso.provider.tntware.com}GetSsoUserFromServiceTicket
#
# RETURNS
#   parameters      GetSsoUserFromServiceTicketResponse - {sso.provider.tntware.com}GetSsoUserFromServiceTicketResponse
#
parameters = nil
puts obj.getSsoUserFromServiceTicket(parameters)

# SYNOPSIS
#   GetServiceTicketFromUserNamePassword(parameters)
#
# ARGS
#   parameters      GetServiceTicketFromUserNamePassword - {sso.provider.tntware.com}GetServiceTicketFromUserNamePassword
#
# RETURNS
#   parameters      GetServiceTicketFromUserNamePasswordResponse - {sso.provider.tntware.com}GetServiceTicketFromUserNamePasswordResponse
#
parameters = nil
puts obj.getServiceTicketFromUserNamePassword(parameters)


