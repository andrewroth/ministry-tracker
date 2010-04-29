class AddTeamLeaderRole < ActiveRecord::Migration

  NEW_STAFF_ROLE = [
              { 
                :ministry_id => 1, 
                :name => "Team Leader", 
                :position => 6, 
                :description => "", 
                :involved => 1
              }
            ]
  UPDATE_STAFF_ROLE_POSITION = [{:name => "Campus Coordinator", :position => 5, :oldposition => 6}, 
                                {:name => "Team Leader", :position => 6, :oldposition => 10}]

  def self.up
    NEW_STAFF_ROLE.each do |role|
      StaffRole.create!(role)
    end

    UPDATE_STAFF_ROLE_POSITION.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:name] })
      if r
        r[:position] = role[:position]
        r.save!
      end
    end
  end

  def self.down
    UPDATE_STAFF_ROLE_POSITION.each do |role|
      r = StaffRole.find(:first, :conditions => { :name => role[:name] })
      if r
        r[:position] = role[:oldposition]
        r.save!
      end
    end

    NEW_STAFF_ROLE.each do |role|
      StaffRole.find(:first, :conditions => { :name => role[:name] }).destroy
    end
  end
end
