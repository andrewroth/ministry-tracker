class AddTranslationKeyToSemesters < ActiveRecord::Migration
  def self.up
    add_column Semester.table_name, :translation_key, :string
    Semester.reset_column_information
    Semester.all.each do |s|
      s.translation_key = s.semester_desc.downcase.gsub(' ', '_')
      s.save!
    end
  end

  def self.down
    remove_column Semester.table_name, :translation_key
  end
end
