class RenameToTeamLeaderAndTeamMember < ActiveRecord::Migration
  RENAME_MINISTRY_ROLES = [{ :old_name => "Campus Coordinator", :new_name => "Team Leader" }, 
                         { :old_name => "Staff Team", :new_name => "Team Member" }]

  def self.up
    RENAME_MINISTRY_ROLES.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:old_name] })
      if r
        r[:name] = role[:new_name]
        r.save!
      end
    end    
  end

  def self.down
    RENAME_MINISTRY_ROLES.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:new_name] })
      if r
        r[:name] = role[:old_name]
        r.save!
      end
    end  
  end
end
