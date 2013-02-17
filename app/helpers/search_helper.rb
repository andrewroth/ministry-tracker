module SearchHelper
  unloadable

  def profile_picture_for_person(person)
    if Cmt::CONFIG[:profile_picture_enabled]
      if person.profile_picture_id.blank?
        image_tag('no_photo_blank.png', :width => '100%')
      else
        image_tag(ProfilePicture.find(person.profile_picture_id).public_filename(:thumb))
      end
    end
  end

  def ac_profile_picture_for_person(person)
    if Cmt::CONFIG[:profile_picture_enabled]
      if person.profile_picture_id.blank?
        image_tag('no_photo_blank.png', :height => '100%', :width => '100%')
      else
        image_tag(ProfilePicture.find(person.profile_picture_id).public_filename(:mini))
      end
    end
  end

  def info_for_person(person)
    info = ""

    if person.staff_role_ids.blank?
      # they are a student
      if person.campuses_concat.present?
        info += "#{person.campuses_concat}"
        info += (person.year_desc.blank? || person.year_desc == "Other") ? "<br>" : "<b> · </b>#{person.year_desc}<br>"
      end
    else
      # they are a staff
      info += person.ministries_concat.present? ? "#{person.ministries_concat}<b> · </b>Staff<br>" : "Staff<br>"
    end

    if person.email.present?
      email = person.email.downcase.gsub(@q,"<strong>#{@q}</strong>")
      info += "#{link_to(email, new_email_url("person[]" => person.id), :class => "sendEmail subtle", :title => "Compose an email to #{person.first_name.capitalize}")}"
    end

    if person.cell_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.cell_phone)} (cell)<br>"
    elsif person.person_local_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.person_local_phone)}<br>"
    elsif person.person_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.person_phone)}<br>"
    end

    info
  end

  def ac_info_for_person(person, actions = false)
    info = ""
    if person.staff_role_ids.blank?
      info += "<span class='noSearchHighlight'>#{person.campuses_concat}</span><br>" if person.campuses_concat.present?
    else
      info += "<span class='noSearchHighlight'>#{person.ministries_concat}</span><br>" if person.ministries_concat.present?
    end

    if actions
      info += link_to("<span class='acEmail'>#{person.email.downcase}</span>", new_email_url("person[]" => person.id), :class => "autoCompleteEmail", :title => "Compose an email to #{person.first_name.capitalize}") if person.email.present?
    else
      info += "<span class='acEmail'>#{person.email.downcase}</span>" if person.email.present?
    end

    info
  end

  def ac_info_for_contact(contact)
    info = ''
    info += %(<span>#{contact.campus_short_desc}</span><br>) if contact.campus_short_desc.present?
    info += %(<span class="acEmail">#{contact.email.downcase}</span>) if contact.email.present?
    info += %(#{ contact.email.present? ? ' · ' : '' }<span>#{contact.mobile_phone.downcase}</span>) if contact.mobile_phone.present?
    info
  end

  def info_for_group(group)
    info = ""


    # display group campus, semester and time

    info += (["#{group.try(:campus_desc)}", "#{group.try(:semester_desc)}", "#{group.meeting_day_and_time_to_string}"]-[""]-[nil]).join("<b> · </b>")

    info += "<br>" unless info.blank?


    # display leaders of the group

    leaders = group.leaders + group.co_leaders

    leaders_array = leaders.collect do |person|
      "#{link_to("#{person.full_name.gsub(/#{@q}/i) {|match| "<strong>#{match}</strong>"} }", "/people/#{person.id}", :class => "subtle")}"
    end

    info += "Led by #{leaders_array.join(", ")}<br>" if leaders_array.first.present?


    # display number of members and any members that matched the search query

    info += link_to("#{pluralize(group.num_members, "member")}", "/groups/#{group.id}", :class => "subtle") if group.num_members.present?

    if group.try(:involvements)
      people_ids = group.involvements.split(",")

      people_array = Person.all(:conditions => ["#{Person._(:id)} IN (?)", people_ids]).collect do |person|
        "#{link_to("#{person.full_name.gsub(/#{@q}/i) {|match| "<strong>#{match}</strong>"} }", "/people/#{person.id}", :class => "subtle")}" if leaders.index(person).nil?
      end
      people_array = people_array-[""]-[nil]

      if people_array.first.present?
        info += "<b> · </b>" if group.num_members.present?
        info += people_array.join(", ")
        info += people_array.size > 1 ? " are in this group" : " is in this group"
      end
    end

    info
  end

  def display_url(url)
    uri = URI.parse(url)
    host = uri.host
    file = File.basename(CGI::unescape(uri.path))
    path = File.dirname(CGI::unescape(uri.path))
    path = "#{path}/" unless path == "/"
    CGI::unescape "#{host}#{truncate(path, :length => 30, :omission => "...#{path[path.length-15,path.length-1]}")}#{file unless file == '/'}"
  end

end

