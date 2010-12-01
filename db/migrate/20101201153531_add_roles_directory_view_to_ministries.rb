class AddRolesDirectoryViewToMinistries < ActiveRecord::Migration
  def self.up
    c = Column.new
    c.title = 'Role'
    c.select_clause = 'name'
    c.from_clause = 'MinistryRole'
    c.source_model = 'MinistryInvolvement'
    c.source_column = 'ministry_role_id'
    c.foreign_key = 'id'
    c.save!

    for m in Ministry.all
      v = m.views.find_or_create_by_title("Roles")
      v.columns << Column.find(1)  # fn
      v.columns << Column.find(2)  # ln
      v.columns << Column.find(7)  # email
      v.columns << Column.find(9)  # campus
      v.columns << Column.find(10) # schoolyear
      v.columns << Column.find(14) # role
      v.save! # update queries
    end
  end

  def self.down
  end
end
