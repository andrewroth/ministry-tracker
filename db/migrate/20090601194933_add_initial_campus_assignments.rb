class AddInitialCampusAssignments < ActiveRecord::Migration
  
  def self.assign_to_campus(p, c_id, m_id)
    CampusInvolvement.create! :person_id => p.id,
                              :campus_id => c_id,
                              :ministry_id => m_id
    # Also make the campus the person's primary campus.
    p.primary_campus_involvement_id = c_id
    p.save!
  end
  
  def self.up
    # Give users campus assignments within their ministry campuses
    if RAILS_ENV == 'development'
      count = 0
      for p in Person.find :all, :offset => 1, :limit => 20    
        if (2..11).include?(p.id)
          # For people in the 'foo' ministry (id = 2), add them
          # to campuses 1,2,3
          assign_to_campus p, count % 3 + 1, 2
        elsif (12..21).include?(p.id)
          # For People in the 'bar' ministry (id = 3), add them
          # to campuses 3,4,5
          assign_to_campus p, count % 3 + 3, 3
        end        
        count += 1;
      end
    end
  end

  def self.down
    # Drop all campus involvements just added
    if RAILS_ENV == 'development'
      for i in 2..21
        CampusInvolvement.find_by_person_id(i).destroy      
      end
      for p in Person.find :all, :offset => 1, :limit => 20
        p.primary_campus_involvement_id = nil
        p.save!
      end
    end
  end

end