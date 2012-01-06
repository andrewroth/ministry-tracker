class AddTranslationKeyToSchoolYears < ActiveRecord::Migration
  def self.up
    add_column SchoolYear.table_name, :translation_key, :string
    SchoolYear.reset_columnInformation
    sy = SchoolYear.find_by_year_desc("1st Year (Undergrad)")
    sy.translation_key = "undergrad_1"
    sy.save!
    sy = SchoolYear.find_by_year_desc("2nd Year (Undergrad)")
    sy.translation_key = "undergrad_2"
    sy.save!
    sy = SchoolYear.find_by_year_desc("3rd year (undergrad)")
    sy.translation_key = "undergrad_3"
    sy.save!
    sy = SchoolYear.find_by_year_desc("4th year (undergrad)")
    sy.translation_key = "undergrad_4"
    sy.save!
    sy = SchoolYear.find_by_year_desc("5th year (undergrad)")
    sy.translation_key = "undergrad_5"
    sy.save!
    sy = SchoolYear.find_by_year_desc("1st year (grad)")
    sy.translation_key = "grad_1"
    sy.save!
    sy = SchoolYear.find_by_year_desc("2nd year (grad)")
    sy.translation_key = "grad_2"
    sy.save!
    sy = SchoolYear.find_by_year_desc("3rd year (grad)")
    sy.translation_key = "grad_3"
    sy.save!
    sy = SchoolYear.find_by_year_desc("other")
    sy.translation_key = "other"
    sy.save!
    sy = SchoolYear.find_by_year_desc("graduated")
    sy.translation_key = "graduated"
    sy.save!
  end

  def self.down
    remove_column SchoolYear.table_name, :translation_key
  end
end
