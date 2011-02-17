module GroupsHelper
  def time_header_text(time)
    if time.min == 0
      "#{time.hour > 12 ? time.hour%12 : time.hour}#{time.hour > 11 ? "pm" : "am"}"
    else
      time.to_s(:time).gsub(/ /,'')
    end
  end

  def time_header_zoom_class(time)
    return "zoom4" if time.min != 0

    case time.hour % 4
    when 1
      return "zoom3"
    when 3
      return "zoom3"
    when 0
      return "zoom2"
    when 2
      return "zoom1"
    end
  end
end
