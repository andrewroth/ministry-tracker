class CreateSchoolYears < ActiveRecord::Migration
  def self.up
    create_table :school_years do |t|
      t.string :name, :level
      t.integer :position
      t.timestamps
    end
    remove_column :campus_involvements, :ministry_role
    add_column :campus_involvements, :graduation_date, :date
    add_column :campus_involvements, :school_year_id, :integer
    add_column :campus_involvements, :major, :string
    add_column :campus_involvements, :minor, :string
    add_column :people, :primary_campus_involvement_id, :integer
    remove_column :people, :primary_campus
  end

  def self.down
    add_column :people, :primary_campus, :string
    remove_column :people, :primary_campus_involvement_id
    remove_column :campus_involvements, :minor
    remove_column :campus_involvements, :major
    remove_column :campus_involvements, :school_year_id
    remove_column :campus_involvements, :graduation_date
    add_column :campus_involvements, :ministry_role, :string, :default => "Involved Student"
    add_column :campus_involvements, :role_id, :integer
    drop_table :school_years
  end
end
