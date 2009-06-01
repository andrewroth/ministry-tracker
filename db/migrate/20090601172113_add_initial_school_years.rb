class AddInitialSchoolYears < ActiveRecord::Migration
  def self.up
    # Create 5 School Years
    if RAILS_ENV == 'development'
      for i in 1..5
        SchoolYear.create! :name => 'Year '+i.to_s(),
                           :level => 'Level '+i.to_s(),
                           :position => i              
      end
    end
  end

  def self.down
    # Delete the 5 created school years.
    if RAILS_ENV == 'development'
      for i in 1..5 do
        SchoolYear.find_by_name('Year '+i.to_s).destroy
      end
    end
  end
  
end
