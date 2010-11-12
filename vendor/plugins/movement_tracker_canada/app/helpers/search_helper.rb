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
        info += (person.year_desc.blank? || person.year_desc == "Other") ? "<br/>" : "<b> · </b>#{person.year_desc}<br/>"
      end
    else
      # they are a staff
      info += person.ministries_concat.present? ? "#{person.ministries_concat}<b> · </b>Staff<br/>" : "Staff<br/>"
    end

    info += "#{person.email.downcase.gsub(@q,"<strong>#{@q}</strong>")}" if person.email.present?

    if person.cell_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.cell_phone)} (cell)<br/>"
    elsif person.person_local_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.person_local_phone)}<br/>"
    elsif person.person_phone.present?
      info += "<b> · </b>" if person.email.present?
      info += "#{number_to_phone(person.person_phone)}<br/>"
    end

    info
  end

  def ac_info_for_person(person)
    info = ""
    if person.staff_role_ids.blank?
      info += "<span class='noSearchHighlight'>#{person.campuses_concat}</span><br/>" if person.campuses_concat.present?
    else
      info += "<span class='noSearchHighlight'>#{person.ministries_concat}</span><br/>" if person.ministries_concat.present?
    end

    info += link_to("#{person.email.downcase}", new_email_url("person[]" => person.id), :class => "autoCompleteEmail", :title => "Goto compose an email to #{person.first_name.capitalize}") if person.email.present?
  end
 
end

