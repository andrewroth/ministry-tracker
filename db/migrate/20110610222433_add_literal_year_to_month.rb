class AddLiteralYearToMonth < ActiveRecord::Migration
  def self.up
    add_column Month.table_name, :month_literalyear, :integer
    Month.reset_column_information
    Month.all.each do |m|
      m.month_desc =~ /(.*) (.*)/
      m.month_literalyear = $2.to_i
      m.save!
    end
  end

  def self.down
    remove_column Month.table_name, :month_literalyear
  end
end
