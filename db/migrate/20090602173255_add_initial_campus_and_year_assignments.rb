class AddInitialCampusAndYearAssignments < ActiveRecord::Migration
  def self.assign_to_campus(p, c_id, m_id, year)
    ci = CampusInvolvement.create! :person_id => p.id,
                                   :campus_id => c_id,
                                   :ministry_id => m_id,
                                   :school_year_id => year
    # Also make the campus the person's primary campus.
    p.primary_campus_involvement_id = ci.id
    p.save!
  end
  
  def self.up
    # Assign the test users to campuses with a year
    if RAILS_ENV == 'development'
      count = 0
      for p in Person.find :all, :offset => 1, :limit => 20
        if (0..9).include?(p.id)
          # For people in the 'foo' ministry (id = 2), add them
          # to campuses 1,2,3 with a year (count % 5 + 1)
          assign_to_campus p, count % 3 + 1, 2, count % 5 + 1
        else
          # For People in the 'bar' ministry (id = 3), add them
          # to campuses 3,4,5 with a year (count % 5 + 1)
          assign_to_campus p, count % 3 + 3, 3, count % 5 + 1
        end
        count += 1;
      end
    end
  end
 
  def self.down
    # Drop all campus involvements just added
    if RAILS_ENV == 'development'
      # Assumption: Tables added were the first 20 rows in the CampusInvolvements table
      for c in CampusInvolvement.find :all, :limit => 20
        c.destroy
      end
      for p in Person.find :all, :offset => 1, :limit => 20
        p.primary_campus_involvement_id = nil
        p.save!
      end
    end
  end
 
end