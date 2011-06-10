class AddYearNumberToYears < ActiveRecord::Migration
  def self.up
    add_column Year.table_name, :year_number, :integer
    Year.reset_column_information
    Year.all.each do |year|
      year.year_desc =~ /(.*) - (.*)/
      year.year_number = $1
      year.save!
    end
  end

  def self.down
    remove_column Year.table_name, :year_number
  end
end
