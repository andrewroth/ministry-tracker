class MinistryInvolvement < ActiveRecord::Base
  load_mappings
  include Common::Core::MinistryInvolvement

  def new_staff_history
    ::StaffInvolvementHistory.new :person_id => person_id, :end_date => Date.today, :ministry_role_id => ministry_role_id, :start_date => (last_history_update_date || start_date), :ministry_involvement_id => id, :ministry_id => ministry_id
  end
end
