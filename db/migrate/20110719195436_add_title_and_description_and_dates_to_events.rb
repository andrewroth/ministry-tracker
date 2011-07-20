class AddTitleAndDescriptionAndDatesToEvents < ActiveRecord::Migration
  def self.up
    begin
      add_column Event.table_name, :title, :string
      add_column Event.table_name, :description, :text
      add_column Event.table_name, :start_date, :datetime
      add_column Event.table_name, :end_date, :datetime
    rescue
    end
  end

  def self.down
    begin
      remove_column Event.table_name, :title
      remove_column Event.table_name, :description
      remove_column Event.table_name, :start_date
      remove_column Event.table_name, :end_date
    rescue
    end
  end
end
