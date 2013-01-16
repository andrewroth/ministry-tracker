class AddTimestampsToSurveyContacts < ActiveRecord::Migration
  def self.up
    add_timestamps SurveyContact.table_name
  end

  def self.down
    remove_timestamps SurveyContact.table_name
  end
end
