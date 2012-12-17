namespace :connect do
  task :import_contacts => :environment do
    include Connect
    Connect.import_survey_contacts
  end

  task :undo_import_contacts => :environment do
    include CiviCRM
    dbm = SurveyContactsHelper::CIVICRM_DATABASE_MAP

    connect = CiviCRM::API.new(:log_tags => ['UNDO IMPORT CONTACTS'])

    undo_contacts = SurveyContact.find(:all, :order => 'id DESC', :limit => 100)
    undo_contacts.each do |c|
      begin
        connect.update(:Contact, :with => { :id => c.connect_id, dbm[:imported_to_pulse][:field] => 0 }) if c.connect_id
      rescue
      else
        c.delete
      end
    end
  end
end