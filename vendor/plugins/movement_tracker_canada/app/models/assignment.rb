class Assignment < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :assignmentstatus
  belongs_to :person
  belongs_to :campus
  belongs_to :status, :class_name => 'Status', :foreign_key => _(:id, :status)

  # This method will return all staff assigned to a specific campus_id
  def self.find_staff_on_campus(campus_id)
    # Need to find the status_id of "Staff" to know what to associate it with
    status_id = Status.find_status_id("Staff")
    find(:all, :conditions => {_(:campus_id) => campus_id, _(:status_id) => status_id})
  end

end
