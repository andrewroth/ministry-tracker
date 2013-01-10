namespace :connect do
  task :import_contacts => :environment do
    include Connect
    Connect.import_survey_contacts
  end

  task :undo_import_contacts => :environment do
    include Connect
    puts "\nStarting from the last SurveyContact this will delete contacts in the Pulse and set their corresponding Connect contact to not imported_to_pulse. Type the number of contacts to unimport or '0' to cancel."
    response = STDIN.gets
    num_contacts_to_undo_import = response.to_i

    if num_contacts_to_undo_import && num_contacts_to_undo_import > 0
      undo_import_contacts = SurveyContact.find(:all, :order => 'id DESC', :limit => num_contacts_to_undo_import)
      undo_import_contacts.each { |c| Connect.undo_import_survey_contact(c) }
    end
  end
end