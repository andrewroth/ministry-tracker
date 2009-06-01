class AddInitialYearAssignments < ActiveRecord::Migration
  def self.up
    # Give every user a random school year assignment
    if RAILS_ENV == 'development'
      count = 0
      for p in Person.find :all
        p.year_in_school = count % 5 + 1
        p.save!
        count += 1;
      end
    end
  end

  def self.down
    # Reset all year values to nil
    if RAILS_ENV == 'development'
      for p in Person.find :all
        p.year_in_school = nil
        p.save!
      end      
    end
  end
end