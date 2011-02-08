class RenameAlumniSchoolYearToGraduated < ActiveRecord::Migration
  def self.up
    asy = SchoolYear.first(:conditions => ["#{SchoolYear.__(:name)} = ?", "Alumni"])
    asy.name = "Graduated" if asy
    asy.save if asy
  end

  def self.down
    asy = SchoolYear.first(:conditions => ["#{SchoolYear.__(:name)} = ?", "Graduated"])
    asy.name = "Alumni" if asy
    asy.save if asy
  end
end
