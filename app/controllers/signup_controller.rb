class SignupController < ApplicationController
  include PersonForm
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus
  before_filter :set_is_staff_somewhere
  before_filter :restrict_everything

  def index
    redirect_to :action => :step1_info
  end

  def step1_info
    @custom_userbar_title = "Signup"
    @person ||= get_person || Person.new
    setup_campuses
  end

  def step1_info_submit
    @person = Person.new(params[:person])
    [:email, :first_name, :last_name, :gender, :local_phone].each do |c|
      @person.errors.add_on_blank(c)
    end

    @primary_campus_involvement = CampusInvolvement.new params[:primary_campus_involvement]
    [:campus_id, :school_year_id].each do |c|
      unless @primary_campus_involvement.send(c).present?
        @person.errors.add(c, :blank)
      end
    end

    if @person.errors.present? || @primary_campus_involvement.errors.present?
      step1_info
      render :action => "step1_info"
    else
      @user = User.find_or_create_from_guid_or_email(nil, params[:person][:email], 
                                               params[:person][:first_name],
                                               params[:person][:last_name])
      @person = @user.person 
      unless @user.just_created && @person.just_created
        @email = params[:person][:email]
        render :action => :step1_verify
      else
        ci = @person.campus_involvements.find :first, :conditions => {
          :campus_id => @primary_campus_involvement.campus_id
        }
        if ci
          ci.update_student_campus_involvement(flash, StudentRole.default_student_role, nil, 
                                               @primary_campus_involvement.school_year_id,
                                               @primary_campus_involvement.campus_id)
        else
          ci = @person.campus_involvements.new
          ci.campus_id = @primary_campus_involvement.campus_id
          ci.school_year_id = @primary_campus_involvement.school_year_id
          ci.start_date = Date.today
          ci.last_history_update_date = Date.today
          ci.ministry_id = ci.derive_ministry.try(:id)
          ci.save!
        end
        session[:signup_person_id] = @person.id
        session[:signup_campus_id] = @primary_campus_involvement.campus_id

        puts "HOOKHERE2 person.#{@person.object_id} '#{@person.try(:just_created)}' user.#{@user.object_id} '#{@user.try(:just_created)}'"

        redirect_to :action => :step1_group
      end
    end
  end

  def step1_group
    @me = @my = @person = Person.find(session[:signup_person_id])
    @campus = Campus.find session[:signup_campus_id]
    @groups = @campus.groups
    @group_types = GroupType.all
    @join = true
    @campus.ensure_campus_ministry_groups_created
    @collection_group = @campus.collection_groups.find :first, 
      :conditions => [ "#{CampusMinistryGroup.__(:ministry_id)} = ?", Ministry.default_ministry ]
    @groups.delete_if { |g| g == @collection_group }
  end

  def step1_verify_submit
    # send verification email
    
  end

  protected

  def set_is_staff_somewhere
    @is_staff_somewhere = {}
  end

  def restrict_everything
    @restrict_all_links = true
  end
end
