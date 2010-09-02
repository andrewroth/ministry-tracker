# put this file in your config/initializers
# in your code call:
#   EventBright.setup(EventBright::KEYS[:api], true)
#   eventbrite_user = EventBright::User.new(EventBright::KEYS[:user])

require 'eventbright'

module EventBright
  #request an api key here: http://www.eventbrite.com/api/key
  #find your user key here: http://www.eventbrite.com/userkeyapi
  KEYS = {:api => "OGU0ODk4MzI3Yjc5", :user => "12831878235758153793"}
end

