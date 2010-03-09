class CampusInvolvement < ActiveRecord::Base
  load_mappings
  include Common::Core::CampusInvolvement
  
  def new_student_history
    StudentInvolvementHistory.new :person_id => person_id, :campus_id => campus_id, :school_year_id => school_year_id, :end_date => Date.today, :ministry_role_id => find_or_create_ministry_involvement.ministry_role_id, :start_date => (last_history_update_date || start_date), :campus_involvement_id => id
  end
  
end
