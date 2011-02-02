class SignupController < ApplicationController
  include PersonForm
  include SemesterSet
  layout :get_layout
  skip_standard_login_stack
  before_filter :set_is_staff_somewhere
  before_filter :restrict_everything
  before_filter :set_custom_userbar_title
  before_filter :set_current_and_next_semester

  def index
    redirect_to :action => :step1_info
  end

  def facebook
    redirect_to :action => :step1_info
  end

  def step1_info
    @person ||= get_person || Person.new
    UserCodesController.clear(session)
    session[:signup_person_params] = nil
    session[:signup_primary_campus_involvement_params] = nil
    session[:signup_person_id] = nil
    session[:signup_campus_id] = nil
    session[:needs_verification] = nil
    session[:joined_collection_group] = nil

    setup_campuses
    @dorms ||= @person.primary_campus_involvement.try(:campus).try(:dorms)
  end

  def get_dorms
    c = Campus.find :first, :conditions => [ "#{Campus._(:id)} = ?", params[:primary_campus_involvement_campus_id] ]
    @dorms = c.try(:dorms)
  end

  def step1_info_submit
    @person = Person.new(params[:person])
    [:email, :first_name, :last_name, :gender, :local_phone].each do |c|
      next if c == :email && logged_in?
      @person.errors.add_on_blank(c)
    end

    # verify email
    email = params[:person] && params[:person][:email]
    if email.present?
      email_regex = ValidatesEmailFormatOf::Regex
      email_error = "Please enter a valid email address.  If the email is already in the Pulse, enter it anyways and a verification email will be sent."
      begin
        domain, local = email.reverse.split('@', 2)
        unless email =~ email_regex and not email =~ /\.\./ and domain.length <= 255 and local.length <= 64 and email.length >= 6
          @person.errors.add_to_base(email_error)
        end
      rescue
        @person.errors.add_to_base(email_error)
      end
    end

    @primary_campus_involvement = CampusInvolvement.new params[:primary_campus_involvement]
    [:campus_id, :school_year_id].each do |c|
      unless @primary_campus_involvement.send(c).present?
        @person.errors.add(c, :blank)
      end
    end

    if @person.errors.present? || @primary_campus_involvement.errors.present?
      @dorms = @primary_campus_involvement.try(:campus).try(:dorms)
      step1_info
      render :action => "step1_info"
    else
      if logged_in?
        @user = current_user
        @person = @user.person 
        # update user based on what was submitted
        @person.first_name = params[:person][:first_name]
        @person.last_name = params[:person][:last_name]
        @person.gender = params[:person][:gender]
        @person.local_phone = params[:person][:local_phone]
        @person.save!
      else
        @user = User.find_or_create_from_guid_or_email(nil, params[:person][:email], 
                                                       params[:person][:first_name],
                                                       params[:person][:last_name],
                                                      false)
        # it's possible that an old person row was found, so update attributes
        @person = @user.person 
        @person.first_name = params[:person][:first_name]
        @person.last_name = params[:person][:last_name]
        @person.gender = params[:person][:gender]
        @person.local_phone = params[:person][:local_phone]
        
        # in order to save major, update it manually again, 
        # since it's stored in a second table in the Cdn schema
        @person.clear_extra_ref
        @person.major = params[:person][:major]
        @person.curr_dorm = params[:person][:curr_dorm]

        # don't save @person yet in case we need to verify their email first
      end

      session[:signup_person_params] = params[:person]
      session[:signup_primary_campus_involvement_params] = params[:primary_campus_involvement]
      session[:signup_person_id] = @person.id
      session[:signup_campus_id] = @primary_campus_involvement.campus_id

      if !logged_in? && !session[:code_valid_for_user_id] && !(@user.just_created && @person.just_created)
        @email = params[:person][:email]
        redirect_to :action => :step1_verify
      else
        @person.save!

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
        ci.find_or_create_ministry_involvement # ensure a ministry involvement is created
        #puts "person.#{@person.object_id} '#{@person.try(:just_created)}' user.#{@user.object_id} '#{@user.try(:just_created)}'"

        redirect_to :action => :step2_group
      end
    end
  end

  def step1_verify
    @me = @my = @person = Person.find(session[:signup_person_id])
    @email = @person.email.downcase
  end

  def step1_verify_submit
    # send verification email
    session[:needs_verification] = true
    unless session[:signup_person_id].blank?
      @me = @my = @person = Person.find(session[:signup_person_id])
      @user = @person.user
      @email = @person.email.downcase
      pass = { :person => session[:signup_person_params],
        :primary_campus_involvement => session[:signup_primary_campus_involvement_params] }
      link = @user.find_or_create_user_code(pass).callback_url(base_url, "signup", "step1_email_verified")
      UserMailer.deliver_signup_confirm_email(@person.email, link)
    else
      flash[:notice] = "<img src='images/silk/exclamation.png' style='float: left; margin-right: 7px;'> <b>Sorry, a verification email could not be sent, please try again or contact helpdesk@c4c.ca</b>"
      redirect_to :action => :step1_info
    end
  end

  def step1_email_verified
    flash[:notice] = "Your email has been verified."
    redirect_to params.merge(:action => :step1_info_submit)
  end

  def step2_group
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
    @groups1 = @campus.groups.find(:all, :conditions => [ "#{Group._(:semester_id)} in (?)", 
      @current_semester.id ],
      :joins => :ministry, :include => { :group_involvements => :person },
      :order => "#{Group.__(:name)} ASC")
    @groups2 = @campus.groups.find(:all, :conditions => [ "#{Group._(:semester_id)} in (?)", 
      @next_semester.id ],
      :joins => :ministry, :include => { :group_involvements => :person },
      :order => "#{Group.__(:name)} ASC")
    @semester_filter_options = [ @current_semester, @next_semester ].collect{ |s| [ s.desc, s.id ] }
    @group_types = GroupType.all
    @join = true
    @signup = true
    @campus.ensure_campus_ministry_groups_created
    @collection_group = @campus.collection_groups
    @groups1.delete_if { |g| @collection_group.index(g) }
    @groups2.delete_if { |g| @collection_group.index(g) }
    # cache of campus names
    campuses = Campus.find(:all, :select => "#{Campus._(:id)}, #{Campus._(:name)}", :conditions => [ "#{Campus._(:id)} IN (?)", ( @groups1 + @groups2 ).collect(&:campus_id).uniq ])
    @campus_id_to_name = Hash[*campuses.collect{ |c| [c.id.to_s, c.name] }.flatten]
  end

  def step2_default_group
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

    semester = params[:semester_id].present? ? Semester.find(params[:semester_id]) : Semester.current

    # Special case - add them to the Bible study group by default
    gt = GroupType.find_by_group_type "Discipleship Group (DG)" # TODO this should be a config var

    @campus = Campus.find session[:signup_campus_id]
    @group = @campus.find_or_create_ministry_group gt, nil, semester
    gi = @group.group_involvements.find_or_create_by_person_id_and_level @person.id, 'member'
    gi.send_later(:join_notifications, base_url)
    session[:joined_collection_group] = true

    redirect_to :action => :step3_timetable
  end

  def step3_timetable_submit
    flash[:notice] = nil
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])
    @user = @person.user
    link = @user.find_or_create_user_code.callback_url(base_url, "signup", "timetable")
    UserMailer.deliver_signup_finished_email(@person.email, link, session[:joined_collection_group])
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

  private

  def get_layout
    session[:from_facebook_canvas] == true ? "facebook_canvas" : "application"
  end

end
