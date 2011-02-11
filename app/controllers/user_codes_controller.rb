class UserCodesController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus

  def show
    uc = UserCode.find_by_code(params[:code])
    if uc
      session[:code_valid_for_user_id] = uc.user.id
      session[:code_valid_for_person_id] = uc.user.person.id
      debugger
      pass_params = uc.pass_hash.merge(:controller => params[:send_to_controller], :action => params[:send_to_action])
      uc.click_count += 1
      uc.save!
      logger.info pass_params.inspect
      redirect_to pass_params
    else
      flash[:notice] = "Sorry, no such code was found."
    end
  end

  def self.clear(session)
    session[:code_valid_for_user_id] = nil
    session[:code_valid_for_person_id] = nil
  end
end
