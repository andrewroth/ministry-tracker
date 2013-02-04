module PeopleHelper

  ARROW_LEFT_INDENT = 11
  BRACKET_LENGTH_INCREMENT_PER_MENTEE = 25
  BRACKET_LENGTH_MIN = 110
  MENTORSHIP_TREE_ROOT_HEIGHT = 210
  MENTEES_VISUAL_INDENT = 30
  MENTEES_BASE_FONTSIZE = 20
  CAMPUS_NOT_ASSIGNED = "Not associated with a campus"
  MEDIUM_PROFILE_PIC_MAX_DIMENSION = 100
  MEDIUM_PROFILE_PIC_FILLER_DIMENSION = 200

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

  def paginate
    @html = ""
    if @page > 0
      @html += link_to("« Previous ", directory_people_url(:page => @page - 1))
    else
      @html += "« Previous "
    end
    @total_pages.times do |i|
      j = i + 1
      if j != @page
        @html += link_to j, directory_people_url(:page => j)
      else
        @html += j.to_s
      end
      @html += " "
    end
    if @page < @total_pages
      @html += link_to("Next »", directory_people_url(:page => @page + 1))
    else
      @html += "Next »"
    end
  end

  def ministry_view_options_for_select(view, ministry)
    authorized_views = ministry.views.reject do |v|
      v.title == "Recruitment" && !authorized?(:show, :recruitments)
    end
    options_for_select(authorized_views.collect {|v| [v.title, v.id]}, view.id)
  end
end
