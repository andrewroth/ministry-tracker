class AddAbreviationToCampus < ActiveRecord::Migration
  def self.up
    add_column :campuses, :abbreviation, :string
  end
  
  def self.down
    remove_column :campuses, :abbreviation
  end
end
