module PeopleHelper
  def campus_filter_message
    "[#{@campus_state.try(:name)}]"
  end
  def campus_state_filter_message
    country = @campus_country.try(:country)
    ("[#{country}] " if country).to_s + "Choose a state in order to choose your primary campus."
  end
  def campus_country_filter_message
    "Choose a country in order to choose your primary campus."
  end

  def parse_url(url)
    desc = url.split('/') 
    url = 'http://' + url if desc.length == 1
    desc = desc.last.split('.')
    desc = desc.length > 1 ? desc[-2] : url
	  return desc, url
  end
end
