class RemoveCityProvinceColumns < ActiveRecord::Migration
  def self.up
    c = Column.find_by_title('City')
    c.view_columns.delete_all
    c = Column.find_by_title('State')
    c.view_columns.delete_all
  end

  def self.down
  end
end
