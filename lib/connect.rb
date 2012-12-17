module Connect

  def self.import_survey_contacts(num_contacts = nil)
    include CiviCRM
    dbm = SurveyContactsHelper::CIVICRM_DATABASE_MAP

    begin
      connect = CiviCRM::API.new(:log_tags => ['IMPORT CONTACTS'])

      # get the contacts to import and include some other info from other entities that we will need
      unimported_contacts = connect.get(:Contact,
                                        :with => { dbm[:imported_to_pulse][:field] => 0, :row_count => num_contacts || connect.max_row_count },
                                        :include => { :CustomValue => { :foreign_key => :entity_id, :hashed_by => :id },
                                                      :Activity => { :foreign_key => :contact_id, :hashed_by => :activity_type_id },
                                                      :Relationship => { :foreign_key => :contact_id, :with => { :relationship_type_id => 10 }, :hashed_by => :relation } })

      if unimported_contacts && unimported_contacts.size > 0
        connect.log :info, "#{unimported_contacts.size} survey contacts to import. Starting import..."
      else
        connect.log :info, 'No survey contacts to import. Exiting.'
        next
      end

      # we'll need these options for key/value conversion
      year_options = connect.get 'OptionValue', :with => { :option_group_id => dbm[:year_option_group][:id] }, :hashed_by => :value
      craving_options = connect.get 'OptionValue', :with => { :option_group_id => dbm[:craving_option_group][:id] }, :hashed_by => :value
      magazine_options = connect.get 'OptionValue', :with => { :option_group_id => dbm[:magazine_option_group][:id] }, :hashed_by => :value
      journey_options = connect.get 'OptionValue', :with => { :option_group_id => dbm[:journey_option_group][:id] }, :hashed_by => :value

    rescue => e
      connect.log :error, e
      connect.log :error, "Exiting."
      fail e.message
    end

    # import the contacts one at a time
    unimported_contacts.each_with_index do |contact, i|
      begin
        connect.log :info, "Importing contact #{i+1} of #{unimported_contacts.size} with id #{contact.id}..."

        if SurveyContact.all(:conditions => { :email => contact.email }).present?
          connect.log :warn, "Contact #{contact.id} with email '#{contact.email}' already exists, skipping import of this contact!"
          next
        end

        # get the contact's school to get the campus_id
        school_contact_id = contact.relationships['Student Currently Attending'].contact_id_b # the school is a Contact in CiviCRM, get the school's id
        school_contact = connect.get('Contact', :with => { :contact_id => school_contact_id }).first

        # the contact's survey which holds some info we need
        survey = contact.activities[dbm[:sept_2012_survey][:id]]

        survey_contact = SurveyContact.new({
          # contact info
          :connect_id => contact.id,
          :missionHub_id => contact.external_identifier,
          :first_name => contact.first_name,
          :last_name => contact.last_name,
          :gender_id => contact.gender_id && contact.gender_id.present? ? contact.gender_id : 0,
          :email => contact.email && contact.email.include?('no_value_set') ? '' : contact.email,
          :cellphone => contact.phone && contact.phone.length < 7 ? '' : contact.phone,
          :campus_id => school_contact.external_identifier,

          # custom values info
          :year => contact.custom_values[dbm[:year][:id]].attr('0'),
          :degree => contact.custom_values[dbm[:degree][:id]].try(:attr, '0'),
          :residence => contact.custom_values[dbm[:residence][:id]].try(:attr, '0'),
          :international => contact.custom_values[dbm[:international][:id]].try(:attr, '0').try(:downcase) == 'yes' ? true : false,

          # survey info
          :priority => survey.attr(dbm[:priority][:field]).downcase == 'no' ? 'Not interested' : survey.attr(dbm[:priority][:field]),
          :craving => craving_options[survey.attr(dbm[:craving][:field])].try(:label),
          :magazine => magazine_options[survey.attr(dbm[:magazine][:field])].try(:label),
          :journey => journey_options[survey.attr(dbm[:journey][:field])].try(:label),
          :interest => survey.attr(dbm[:interest][:field]).try(:scan, /(\d+)/).try(:flatten).try(:first),
          :data_input_notes => survey.attr(dbm[:data_input_notes][:field]),

          :status => survey.attr(dbm[:priority][:field]).downcase == 'not interested' ? 3 : 0
        })
        survey_contact.save!

      rescue => e
        connect.log :error, "Failed to import contact #{contact.try(:id)}", e

      else # if no exceptions raised
        begin
          # update the contact in CiviCRM as successfully imported
          connect.update :Contact, :with => { :id => survey_contact.connect_id, dbm[:imported_to_pulse][:field] => 1 }
        rescue => e
          connect.log :error, "Failed to update contact #{contact.try(:id)} as imported", e
        end
      end
    end

    connect.log :info, "Finished import, exiting.\n"
  end

end