module PeopleHelper
  def parse_url(url)
    desc = url.split('/') 
    url = 'http://' + url if desc.length == 1
    desc = desc.last.split('.')
    desc = desc.length > 1 ? desc[-2] : url
	  return desc, url
  end
end
