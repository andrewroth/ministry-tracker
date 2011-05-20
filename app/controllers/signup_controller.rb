class SignupController < ApplicationController
  include PersonForm
  include SemesterSet
  layout :get_layout
  skip_standard_login_stack
  before_filter :set_is_staff_somewhere
  before_filter :restrict_everything
  before_filter :set_custom_userbar_title
  before_filter :set_current_and_next_semester
  before_filter :get_invitation, :only => [:step2_info, :step2_info_submit]

  def index
    redirect_to :action => :step1_group
  end

  def facebook
    redirect_to :action => :step1_group
  end

  def step2_info
    @person ||= get_person || Person.new
    @person.email = @group_invitation.recipient_email if @group_invitation
    UserCodesController.clear(session)
    setup_campuses
    @campus = Campus.find(session[:signup_campus_id])
    @dorms ||= @campus.try(:dorms)
    
    if @group_invitation.present?
      @back_button = false
      @next_button_text = "Join group"
    end
  end

  def get_dorms
    c = Campus.find :first, :conditions => [ "#{Campus._(:id)} = ?", params[:primary_campus_involvement_campus_id] ]
    @dorms = c.try(:dorms)
  end

  def step2_info_submit
    # if no person in params get person from session
    @person = params[:person].present? ? Person.new(params[:person]) : get_person
    @person.email = @group_invitation.recipient_email if @group_invitation
    debugger
    # make sure we have all the right info
    [:email, :first_name, :last_name, :local_phone].each do |c|
      next if c == :email && logged_in?
      @person.errors.add_on_blank(c)
    end
    @person.errors.add(:gender, :blank) if @person.gender.blank?
    @person.errors.add(:school_year, :blank) unless (@person.primary_campus_involvement && @person.primary_campus_involvement.school_year_id.present?) ||
                                                    (params[:primary_campus_involvement] && params[:primary_campus_involvement][:school_year_id].present?)

    # verify email
    email = @person && @person.user && @person.email
    if email.present?
      email_error = "Please enter a valid email address. If the email is already in the Pulse, enter it anyways and a verification email will be sent."
      begin
        @person.errors.add_to_base(email_error) unless ValidatesEmailFormatOf::validate_email_format(email).nil?
      rescue
        @person.errors.add_to_base(email_error)
      end
    end

    if @person.errors.present?
      @dorms = @primary_campus_involvement.try(:campus).try(:dorms)
      step2_info
      render :action => "step2_info"
    else
      school_year_id = (params[:primary_campus_involvement] && params[:primary_campus_involvement][:school_year_id]) ||
                       @person.primary_campus_involvement.school_year_id
      @primary_campus_involvement = CampusInvolvement.new :school_year_id => school_year_id, :campus_id => session[:signup_campus_id]
      [:campus_id, :school_year_id].each do |c|
        unless @primary_campus_involvement.send(c).present?
          @person.errors.add(c, :blank)
        end
      end
      
      if logged_in?
        @user = current_user
        old_person = @user.person
        old_person.first_name = @person.first_name if @person.first_name.present?
        old_person.last_name = @person.last_name if @person.last_name.present?
        old_person.gender_id = @person.gender_id if @person.gender_id.present?
        old_person.local_phone = @person.local_phone if @person.local_phone.present?
        old_person.save!
      else
        @user = User.find_or_create_from_guid_or_email(nil, @person.email, 
                                                       @person.first_name,
                                                       @person.last_name,
                                                       false)
        # it's possible that an old person row was found, so update attributes
        old_person = @user.person
        old_person.first_name = @person.first_name if @person.first_name.present?
        old_person.last_name = @person.last_name if @person.last_name.present?
        old_person.gender_id = @person.gender_id if @person.gender_id.present?
        old_person.local_phone = @person.local_phone if @person.local_phone.present?
        
        # in order to save major, update it manually again, 
        # since it's stored in a second table in the Cdn schema
        old_person.clear_extra_ref
        old_person.major = @person.major if @person.major.present?
        old_person.curr_dorm = @person.curr_dorm if @person.curr_dorm.present?
        # don't save @person yet in case we need to verify their email first
      end
      @person = old_person

      session[:signup_person_params] = params[:person]
      session[:signup_primary_campus_involvement_params] = params[:primary_campus_involvement]
      session[:signup_person_id] = @person.id
      session[:signup_campus_id] = @primary_campus_involvement.campus_id

      if !logged_in? && !session[:code_valid_for_user_id] && !(@user.just_created && @person.just_created)
        @email = params[:person][:email]
        redirect_to :action => :step2_verify
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
        
        # join groups here
        joingroups_from_hash(session[:signup_groups], !@group_invitation.present?) # if group invitation then join group even if it requires approval
        if semester_id = session[:signup_collection_group_semester_id]
          join_default_group(session[:signup_campus_id], semester_id)
        end
        @group_invitation.accept if @group_invitation
        
        redirect_to :action => :step3_timetable
      end
    end
  end

  def step2_verify
    @me = @my = @person = Person.find(session[:signup_person_id])
    @email = @person.email.downcase
  end

  def step2_verify_submit
    # send verification email
    session[:needs_verification] = true
    unless session[:signup_person_id].blank?
      @me = @my = @person = Person.find(session[:signup_person_id])
      @user = @person.user
      @email = @person.email.downcase
      pass = { :person => session[:signup_person_params],
        :primary_campus_involvement => session[:signup_primary_campus_involvement_params],
        :signup_groups => session[:signup_groups],
        :signup_campus_id => session[:signup_campus_id] }
      link = @user.find_or_create_user_code(pass).callback_url(base_url, "signup", "step2_email_verified")
      UserMailer.deliver_signup_confirm_email(@person.email, link)
    else
      flash[:notice] = "<img src='images/silk/exclamation.png' style='float: left; margin-right: 7px;'> <b>Sorry, a verification email could not be sent, please try again or contact helpdesk@c4c.ca</b>"
      redirect_to :action => :step2_info
    end
  end

  def step2_email_verified
    session[:signup_groups] = params[:signup_groups]
    session[:signup_campus_id] = params[:signup_campus_id]
    flash[:notice] = "Your email has been verified."
    redirect_to params.merge(:action => :step2_info_submit)
  end

  # this is actually more of just showing the campus dropdown
  def step1_group
    session[:signup_person_params] = nil
    session[:signup_primary_campus_involvement_params] = nil
    session[:signup_person_id] = nil
    session[:signup_campus_id] = nil
    session[:signup_groups] = nil
    session[:signup_collection_group_semester_id] = nil
    session[:needs_verification] = nil
    session[:joined_collection_group] = nil

    @person = get_person || Person.new
    setup_campuses
  end

  def step1_default_group
    get_person
    if @person
      join_default_group(session[:signup_campus_id], params[:semester_id])
    else
      session[:signup_collection_group_semester_id] = params[:semester_id]
    end
    redirect_to :action => :step2_info
  end

  def step1_group_from_campus
=begin
    @signup = true
    if session[:needs_verification] && !session[:code_valid_for_user_id]
      flash[:notice] = "Sorry, your email has not been verified yet."
      render :inline => "", :layout => true
      return
    elsif !session[:signup_person_id]
      redirect_to :action => :step1_info
      return
    end
=end

    if params[:primary_campus_involvement_campus_id] == ""
      render :update do |page|
        page["#groups"].html "Sorry, you must provide a campus to choose a group."
      end
      return
    end

    @ministry = Ministry.default_ministry
    get_person
    unless @person
      @me = @my = @person = Person.new
    end
    #@campus = Campus.find session[:signup_campus_id]
    session[:signup_campus_id] = params[:primary_campus_involvement_campus_id]
    @campus = Campus.find params[:primary_campus_involvement_campus_id]
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

  def step3_timetable_submit
    flash[:notice] = nil
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])
    @user = @person.user
    link = @user.find_or_create_user_code.callback_url(base_url, "signup", "timetable")
    UserMailer.deliver_signup_finished_email(@person.email, link, session[:joined_collection_group])
    
    @group_contact_email = session[:joined_group_contact_email]
    
    if session[:from_facebook_canvas] == true
      @finished_button_text = "Goto Facebook"
    elsif logged_in?
      @finished_button_text = "Goto the dashboard"
    else
      @finished_button_text = "Goto the sign in page"
    end
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
    @custom_userbar_title = "JOIN A GROUP"
  end

  def join_default_group(campus_id, semester_id)
    throw "join_group requires @person" unless @person
    @campus = Campus.find campus_id

    semester = semester_id.present? ? Semester.find(semester_id) : Semester.current

    # Special case - add them to the Bible study group by default
    gt = GroupType.find_by_group_type "Discipleship Group (DG)" # TODO this should be a config var

    @group = @campus.find_or_create_ministry_group gt, nil, semester
    gi = @group.group_involvements.find_or_create_by_person_id_and_level @person.id, 'member'
    gi.send_later(:join_notifications, base_url)
    session[:joined_collection_group] = true
  end

  def joingroups_from_hash(involvement_info, requested = nil)
    (involvement_info || {}).each_pair do |group_id, level|
      if %w(member interested).include?(level)
        group = Group.find group_id
        requested = (level == "member" ? group.needs_approval : false) if requested.nil?
        gi = GroupInvolvement.create_group_involvement(@person.id, group_id, level, requested)
        gi.send_later(:join_notifications, base_url)
        session[:joined_group_contact_email] = group.email
      end
    end
  end

  private

  def get_layout
    session[:from_facebook_canvas] == true ? "facebook_canvas" : "application"
  end
  
  def get_invitation
    if session[:signup_group_invitation_id]
      @group_invitation = GroupInvitation.first(:conditions => {:id => session[:signup_group_invitation_id]}) 
      
      if logged_in? && current_user.person && current_user.person.id != @group_invitation.recipient_person_id
        @group_invitation = nil
        session[:signup_group_invitation_id] = nil
        flash[:notice] = "<big>We're sorry, something went wrong with your group invitation.<br/><br/>We'd still love you to join a group though, so go ahead and find the group below and join!</big>"
        redirect_to signup_url
        return
      elsif @group_invitation.has_response?
        @group_invitation = nil
        session[:signup_group_invitation_id] = nil
      else
        # setup the group to join
        session[:signup_groups] ||= {}
        session[:signup_groups][@group_invitation.group_id] = GroupInvitation::GROUP_INVITE_LEVEL
        session[:signup_campus_id] = @group_invitation.group.campus.id
      end
    end
  end

end



