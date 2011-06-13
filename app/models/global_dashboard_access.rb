class GlobalDashboardAccess < ActiveRecord::Base
  def person
    User.find_by_guid(guid).try(:person)
  end

  def self.setup(guid, fn, ln, email)
    u = User.find_by_guid(guid)
    unless u
      u = Person.create_new_cim_hrdb_account(guid, fn, ln, email)
      p = u.person
      p.timetable
      mi = p.ministry_involvements.new
      mi.ministry = Ministry.find_by_name "CCCI Global Team"
      mi.ministry_role = StaffRole.find_by_name "International Staff"
      mi.save!
    end

    debugger
    GlobalDashboardAccess.find_or_create_by_guid_and_fn_and_ln_and_email(guid, fn, ln, email)
  end

  def self.import
    GlobalCountry.parse("global_dashboad_import.csv", 1) do |values|
      puts values.inspect
      self.setup(*values)
    end
  end
end
