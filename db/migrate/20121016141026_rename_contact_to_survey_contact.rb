class RenameContactToSurveyContact < ActiveRecord::Migration
  def self.up
    Activity.update_all("reportable_type = 'SurveyContact'", ["reportable_type = ?", "Contact"])
    Note.update_all("noteable_type = 'SurveyContact'", ["noteable_type = ?", "Contact"])
    Permission.update_all("controller = 'survey_contacts'", ["controller = ?", "contacts"])
  end

  def self.down
    Activity.update_all("reportable_type = 'Contact'", ["reportable_type = ?", "SurveyContact"])
    Note.update_all("noteable_type = 'Contact'", ["noteable_type = ?", "SurveyContact"])
    Permission.update_all("controller = 'contacts'", ["controller = ?", "survey_contacts"])
  end
end
