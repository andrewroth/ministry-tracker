class AddDescriptionAndPositionToMinistryRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_roles, :position, :integer
    add_column :ministry_roles, :description, :string
    add_column :ministry_involvements, :ministry_role_id, :integer
    
    MinistryRole.connection.execute("update ministry_roles set position = 1 where name = 'Director'")
    MinistryRole.connection.execute("update ministry_roles set position = 2 where name = 'Staff'")
  end

  def self.down
    remove_column :ministry_involvements, :ministry_role_id
    remove_column :ministry_roles, :description
    remove_column :ministry_roles, :position
  end
end
