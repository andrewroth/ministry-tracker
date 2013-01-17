class AddUpdatedAtValuesToExistingSurveyContacts < ActiveRecord::Migration
  def self.up
    date_time = DateTime.new(2012, 9, 1)
    SurveyContact.update_all(["updated_at = ?, created_at = ?", date_time, date_time], ["updated_at IS NULL OR created_at IS NULL"])
  end

  def self.down
    date_time = DateTime.new(2012, 9, 1)
    SurveyContact.update_all(["updated_at = ?, created_at = ?", nil, nil], ["updated_at = ? AND created_at = ?", date_time, date_time])
  end
end
