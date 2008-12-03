class AddDescriptionAndPositionToMinistryRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_roles, :position, :integer
    add_column :ministry_roles, :description, :string
    add_column :ministry_involvements, :ministry_role_id, :integer
    add_column :ministry_roles, :type, :string
    
    MinistryRole.connection.execute("update ministry_roles set position = 1, type = 'StaffRole' where name = 'Director'")
    MinistryRole.connection.execute("update ministry_roles set position = 2, type = 'StaffRole' where name = 'Staff'")
    MinistryRole.connection.execute("update ministry_roles set position = 3, type = 'StudentRole' where name like 'Student%'")
    MinistryInvolvement.find(:all).each do |mi|
      mr = MinistryRole.find(:first, :conditions => {:ministry_id => mi.ministry.root.id, :name => mi.ministry_role})
      if mr
        mi.update_attribute(:ministry_role_id, mr.id)
      end
    end
    MinistryRole.connection.execute("update ministry_involvements mi, ministry_roles mr set mi.ministry_role_id = mr.id where mi.ministry_role = mr.name AND mi.ministry_id = mr.ministry_id")
    # Add some roles to all top level ministries
    Ministry.find(:all, :conditions => {:parent_id => nil} ).each do |ministry|
      if ministry.student_roles.empty?
        ministry.student_roles << StudentRole.new(:name => 'Ministry Leader', :description => 'a student who oversees a campus, eg LINC leader') unless ministry.ministry_roles.find_by_name('Ministry Leader')
        ministry.student_roles << StudentRole.new(:name => 'Student Leader') unless ministry.ministry_roles.find_by_name('Student Leader')
        ministry.student_roles << StudentRole.new(:name => 'Involved Student', :description => 'we are saying has been attending events for at least 6 months') unless ministry.ministry_roles.find_by_name('Involved Student')
        ministry.student_roles << StudentRole.new(:name => 'Student') unless ministry.ministry_roles.find_by_name('')
      end
      if ministry.staff_roles.empty?
        ministry.staff_roles << StaffRole.new(:name => 'Campus Coordinator', :position => 2) unless ministry.ministry_roles.find_by_name('Campus Coordinator')
        ministry.staff_roles << StaffRole.new(:name => 'Missionary', :position => 3) unless ministry.ministry_roles.find_by_name('Missionary')
        ministry.staff_roles << StaffRole.new(:name => 'Admin', :position => 1) unless ministry.ministry_roles.find_by_name('Admin')
      end
      if ministry.other_roles.empty?
        ministry.other_roles << OtherRole.new(:name => 'Registration Incomplete', :position => 8, :description => 'A leader has registered them, but user has not completed rego and signed the privacy policy') unless ministry.ministry_roles.find_by_name('Registration Incomplete')
        ministry.other_roles << OtherRole.new(:name => 'Approval Pending', :position => 9, :description => 'They have applied, but a leader has not verified their application yet') unless ministry.ministry_roles.find_by_name('Approval Pending')
        ministry.other_roles << OtherRole.new(:name => 'Honourary Member', :position => 10, :description => 'not a valid student or missionary, but we are giving them limited access anyway') unless ministry.ministry_roles.find_by_name('Honourary Member')
      end
    end
    # Remove roles from non root level ministries
    ministries = Ministry.find(:all, :conditions => "parent_id is not null" )
    MinistryRole.connection.execute("delete from ministry_roles where ministry_id IN (#{ministries.collect(&:id).join(',')})")
    MinistryRole.connection.execute("delete from ministry_involvements where ministry_role_id is null")
    
    # Create a ministry involvement row for each student
    ministry_roles = {}
    Ministry.find(:all).each do |ministry|
      ministry_roles[ministry.id] = ministry.student_roles.first.id
    end
    CampusInvolvement.find(:all).each do |ci|
      mi = MinistryInvolvement.find(:first, :conditions => {:person_id => ci.person_id, :ministry_id => ci.ministry_id})
      unless mi
        MinistryInvolvement.create(:person_id => ci.person_id, :ministry_id => ci.ministry_id, :ministry_role_id => ministry_roles[ci.ministry_id])
      end
    end
  end

  def self.down
    remove_column :ministry_roles, :type
    remove_column :ministry_involvements, :ministry_role_id
    remove_column :ministry_roles, :description
    remove_column :ministry_roles, :position
  end
end
