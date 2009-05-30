class AddCampusAndSchoolYearColumns < ActiveRecord::Migration
  def self.up
    Column.reset_column_information
    Column.create! :title => 'Campus',
      :from_clause => 'Campus',
      :select_clause => 'name',
      :source_model => 'CampusInvolvement',
      :source_column => 'campus_id',
      :foreign_key => 'id'
    Column.create! :title => 'SchoolYear',
      :from_clause => 'SchoolYear',
      :select_clause => 'name',
      :source_model => 'CampusInvolvement',
      :source_column => 'school_year_id',
      :foreign_key => 'id'
  end

  def self.down
    Column.delete_all "title in ('Campus','SchoolYear')"
  end
end
