class SignupController < ApplicationController
  include PersonForm
  skip_standard_login_stack
  before_filter :set_is_staff_somewhere
  before_filter :restrict_everything
  before_filter :set_custom_userbar_title

  def index
    redirect_to :action => :step1_info
  end

  def step1_info
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
      if logged_in?
        @user = current_user
        @person = @user.person 
        # update user based on what was submitted
        @person.first_name = params[:person][:first_name]
        @person.last_name = params[:person][:first_name]
        @person.email = params[:person][:email]
        @person.gender = params[:person][:gender]
        @person.local_phone = params[:person][:local_phone]
        @person.save!
      else
        @user = User.find_or_create_from_guid_or_email(nil, params[:person][:email], 
                                                       params[:person][:first_name],
                                                       params[:person][:last_name])
        @person = @user.person 
      end

      session[:signup_person_params] = params[:person]
      session[:signup_primary_campus_involvement_params] = params[:primary_campus_involvement]
      session[:signup_person_id] = @person.id
      session[:signup_campus_id] = @primary_campus_involvement.campus_id

      if !logged_in? && !session[:code_valid_for_user_id] && !(@user.just_created && @person.just_created)
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
        #puts "person.#{@person.object_id} '#{@person.try(:just_created)}' user.#{@user.object_id} '#{@user.try(:just_created)}'"
        redirect_to :action => :step1_group
      end
    end
  end

  def step1_group
    @signup = true
    if session[:needs_verification] && !session[:code_valid_for_user_id]
      flash[:notice] = "Sorry, your email has not been verified yet."
      render :inline => "", :layout => true
      return
    elsif !session[:signup_person_id]
      redirect_to :action => :step1_info
      return
    end

    @ministry = Ministry.default_ministry
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
    session[:needs_verification] = true
    @me = @my = @person = Person.find(session[:signup_person_id])
    @user = @person.user
    pass = { :person => session[:signup_person_params], 
      :primary_campus_involvement => session[:signup_primary_campus_involvement_params] }
    link = @user.find_or_create_user_code(pass).callback_url(base_url, "signup", "step1_email_verified")
    UserMailer.deliver_signup_confirm_email(@person.email, link)
  end

  def step1_email_verified
    flash[:notice] = "Your email has been verified."
    redirect_to params.merge(:action => :step1_info_submit)
  end

  def step1_default_group
    if session[:needs_verification] && !session[:code_valid_for_user_id]
      flash[:notice] = "Sorry, your email has not been verified yet."
      render :inline => "", :layout => true
      return
    elsif !session[:signup_person_id]
      redirect_to :action => :step1_info
      return
    end

    @me = @my = @person = Person.find(session[:signup_person_id])
    @campus = Campus.find session[:signup_campus_id]

    # Special case - add them to the Bible study group by default
    gt = GroupType.find_by_group_type "Bible Study"

    @campus = Campus.find session[:signup_campus_id]
    @group = @campus.find_or_create_ministry_group gt
    @group.group_involvements.find_or_create_by_person_id_and_level :person_id => @person.id, :level => 'member'
    flash[:notice] = "Thank you.  You will be put into a group and someone will notify you of the group details."

    redirect_to :action => :step2_timetable
  end

  def step2_timetable_submit
    flash[:notice] = nil
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])
    @user = @person.user
    link = @user.find_or_create_user_code.callback_url(base_url, "signup", "timetable")
    UserMailer.deliver_signup_confirm_email(@person.email, link)
  end

  def finished
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])

    redirect_to logged_in? ? dashboard_url : login_url
  end

  def timetable
    @user = User.find session[:code_valid_for_user_id]
    self.current_user = @user
    @me = @my = @person = @user.person
    redirect_to edit_person_timetable_path(@me.id, (@my.timetable || Timetable.create(:person_id => @me.id)).id)
  end

  protected

  def set_is_staff_somewhere
    @is_staff_somewhere = {}
  end

  def restrict_everything
    @restrict_all_links = true
  end

  def set_custom_userbar_title
    @custom_userbar_title = "Signup"
  end
end
