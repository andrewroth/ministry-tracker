class CimHrdbStaffController < ApplicationController
  unloadable
  layout 'manage'

  def change
    @cim_hrdb_person = Person.find(params[:person_id])
    @cim_hrdb_staff = @cim_hrdb_person.cim_hrdb_staff

    @cim_hrdb_staff.is_active = @cim_hrdb_staff.is_active == 0 ? 1 : 0

    if @cim_hrdb_staff.save
      render(:text => "success")
    else
      flash[:notice] = 'OOPS! Could not change is active!'
      render(:update) { |page| page.redirect_to edit_cim_hrdb_person_path(@cim_hrdb_person)}
    end
  end

end
