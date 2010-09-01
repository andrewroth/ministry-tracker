require 'eventbright'

@eventbrite_api_key = "OGU0ODk4MzI3Yjc5" #request an api key here: http://www.eventbrite.com/api/key
@eventbrite_user_key = "12831878235758153793" #find your user key here: http://www.eventbrite.com/userkeyapi

EventBright.setup(@eventbrite_api_key)
@eventbrite_user = EventBright::User.new(@eventbrite_user_key)

