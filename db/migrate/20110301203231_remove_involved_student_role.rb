class RemoveInvolvedStudentRole < ActiveRecord::Migration
  ROLES = [{ :ministry_role_id => 7, :ministry_id => 1, :ministry_role_type => "StudentRole", :ministry_role_name => "Involved Student"}]


  def self.up
    ROLES.each do |roles|
      mrole = MinistryRole.find(:first, :conditions => { :name => roles[:ministry_role_name] })
      mrole.destroy unless mrole.nil?
    end
  end

  def self.down
    ROLES.each do |roles|
      StudentRole.create!({ :ministry_id => roles[:ministry_id], :name => roles[:ministry_role_name] })
    end
  end
  
end