class AddPositionToYearInSchool < ActiveRecord::Migration
  def self.up
    begin
      add_column SchoolYear.table_name, :position, :integer
      SchoolYear.reset_column_information
      SchoolYear.all.each do |sy|
        sy.position = sy.id
        sy.save
      end
    end
  rescue
  end

  def self.down
    remove_column SchoolYear.table_name, :position
  end
end
