def self.assign_to_campus(p, c_id, m_id, year)
  involvement = CampusInvolvement.seed(:person_id, :campus_id, :ministry_id, :school_year_id) do |ci|
                  ci.person_id = p.id
                  ci.campus_id = c_id
                  ci.ministry_id = m_id
                  ci.school_year_id = year
                end
  # Also make the campus the person's primary campus.
  p.primary_campus_involvement_id = involvement.id
  p.save!
end

# Assign the test users to campuses with a year
count = 0
Person.find(:all, :offset => 1, :limit => 20).each do |p|
  if count % 2 == 0
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
