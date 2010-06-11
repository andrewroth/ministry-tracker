module PeopleHelper
  def highlight_if_requested
    if params[:set_campus_requested] == 'true'
      %|class="warning"|
    end
  end
  def campus_filter_message
    "[#{@campus_state}]"
  end
  def campus_state_filter_message
    country = CmtGeo.lookup_country_name(@campus_country)
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

  def currently_impersonating
    session[:impersonator].present?
  end
end
