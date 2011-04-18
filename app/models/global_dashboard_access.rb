class GlobalDashboardAccess < ActiveRecord::Base
  def person
    User.find_by_guid(guid).try(:person)
  end
end
