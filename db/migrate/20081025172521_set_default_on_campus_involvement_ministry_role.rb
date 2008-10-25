class SetDefaultOnCampusInvolvementMinistryRole < ActiveRecord::Migration
  def self.up
    change_column_default CampusInvolvement.table_name, :ministry_role, "Involved Student"
    CampusInvolvement.connection.execute("Update #{CampusInvolvement.table_name} set ministry_role = 'Involved Student'")
    add_column CampusInvolvement.table_name, :added_by_id, :integer
  end

  def self.down
    remove_column CampusInvolvement.table_name, :added_by_id
    change_column_default CampusInvolvement.table_name, :ministry_role, nil
  end
end
