class SignupController < ApplicationController
  include PersonForm
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data

  def index
    redirect_to :action => :step1_info
  end

  def step1_info
    @person = Person.new
    setup_campuses
  end

  def step1_info_submit
    # {"person"=>{"email" => "a@b.com", "local_phone"=>"905-528-5907", "gender"=>"1", "last_name"=>"Smith", "first_name"=>"John"}, "commit"=>"Next", "primary_campus_involvement"=>{"campus_id"=>"1", "school_year_id"=>"1"}, "primary_campus_state"=>"ON", "primary_campus_country"=>"CA"}
    p = User.find_or_create_from_guid_or_email(nil, params[:person][:email], 
                                               params[:person][:first_name],
                                               params[:person][:last_name])
  end

  def step1_campus
  end
end
