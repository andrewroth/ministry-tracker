require 'cas_auth'

CAS::Filter.logger = RAILS_DEFAULT_LOGGER if !RAILS_DEFAULT_LOGGER.nil?
CAS::Filter.logger = config.logger if !config.logger.nil?

class ActionController::Base
  append_before_filter CAS::Filter
end
