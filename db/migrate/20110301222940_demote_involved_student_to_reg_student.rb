class DemoteInvolvedStudentToRegStudent < ActiveRecord::Migration
  INVOLVED_STUDENT_ROLE_ID = 7
  REGULAR_STUDENT_ROLE_ID = 8

  def self.up
    destroyed = false
    MinistryInvolvement.find_all_by_ministry_role_id(INVOLVED_STUDENT_ROLE_ID).each do | mi |
      min_invs = MinistryInvolvement.find_all_by_person_id_and_ministry_id(mi.person_id, mi.ministry_id)
      if min_invs.size > 1
        min_invs.each do |mi2|
          if mi2.ministry_role_id != INVOLVED_STUDENT_ROLE_ID          
            mi.destroy     # remove 'mi' where role = "Involved Student" (i.e. we have a backup role)
            destroyed = true
            break
          end
          if destroyed == false # if no backup role, simply switch "Involved Student" to "Student"
            mi[:ministry_role_id] = REGULAR_STUDENT_ROLE_ID
          else
            destroyed = false
          end
        end
      else  # if only one ministry involvement found, simply switch "Involved Student" to "Student"
        mi[:ministry_role_id] = REGULAR_STUDENT_ROLE_ID
        mi.save!       
      end

    end
  end

  def self.down
  # use database ROLLBACK because I ain't creating a backup table just in case data update reversal is wanted
  end
end

