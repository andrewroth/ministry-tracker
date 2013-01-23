class AddCreatedAtValuesToExistingSurveyContacts < ActiveRecord::Migration
  def self.up
    date_time = DateTime.new(2012, 9, 1)
    SurveyContact.update_all(["created_at = ?", date_time], ["created_at IS NULL"])
  end

  def self.down
    date_time = DateTime.new(2012, 9, 1)
    SurveyContact.update_all(["created_at = ?", nil], ["created_at = ?", date_time])
  end
end
