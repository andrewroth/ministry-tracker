class AddMoreBackYearsAndMonths < ActiveRecord::Migration
  def self.up
    y = Year.find_or_create_by_year_desc("2005 - 2006")

    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("September 2005", 9, y.id, 2005, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("October 2005", 10, y.id, 2005, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("November 2005", 11, y.id, 2005, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("December 2005", 12, y.id, 2005, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("January 2006", 1, y.id, 2005, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("February 2006", 2, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("March 2006", 3, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("April 2006", 4, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("May 2006", 5, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("June 2006", 6, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("July 2006", 7, y.id, 2006, nil)
    m = Month.find_or_create_by_month_desc_and_month_number_and_year_id_and_month_calendaryear_and_semester_id("August 2006", 8, y.id, 2006, nil)
  end

  def self.down
  end
end
