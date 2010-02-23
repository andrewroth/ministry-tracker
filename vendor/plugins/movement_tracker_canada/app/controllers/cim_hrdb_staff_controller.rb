class CimHrdbStaffController < ApplicationController
  unloadable
  layout 'manage'

  def change_or_add
    @cim_hrdb_person = Person.find(params[:person_id])

    # create a new entry in the staff table if one does not exist
    if @cim_hrdb_person.cim_hrdb_staff.nil?
      @cim_hrdb_staff = CimHrdbStaff.new
      @cim_hrdb_staff.person_id = @cim_hrdb_person.id
      @cim_hrdb_staff.is_active = 0
      
      unless @cim_hrdb_staff.save
        flash[:notice] = 'OOPS! Could not change is active!'
        render(:update) { |page| page.redirect_to edit_cim_hrdb_person_path(@cim_hrdb_person)}
      end
    end

    @cim_hrdb_staff = CimHrdbStaff.all(:conditions => {:person_id => @cim_hrdb_person.id}).first

    # flip the is_active boolean
    @cim_hrdb_staff.is_active = @cim_hrdb_staff.is_active == 0 ? 1 : 0

    if @cim_hrdb_staff.save
      render(:text => "success")
    else
      flash[:notice] = 'OOPS! Could not change is active!'
      render(:update) { |page| page.redirect_to edit_cim_hrdb_person_path(@cim_hrdb_person)}
    end
  end

end
