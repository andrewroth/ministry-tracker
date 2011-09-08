class SignupController < ApplicationController
  require "geoip"
  include PersonForm
  include SemesterSet
  layout :get_layout
  skip_standard_login_stack
  before_filter :set_is_staff_somewhere
  before_filter :restrict_everything
  before_filter :set_custom_userbar_title
  before_filter :set_current_and_next_semester
  before_filter :get_invitation, :only => [:step1_group, :step2_info, :step2_info_submit]


  def index
    redirect_to :action => :step1_group
  end

  def facebook
    redirect_to :action => :step1_group
  end


  def step1_group
    session[:signup_joined_group_id] = nil
    session[:signup_person_params] = nil
    session[:signup_primary_campus_involvement_params] = nil
    session[:signup_person_id] = nil
    session[:signup_campus_id] = nil
    session[:signup_groups] = nil
    session[:signup_collection_group_semester_id] = nil
    session[:needs_verification] = nil
    session[:joined_collection_group] = nil
    session[:sent_timetable_email] = nil

    @person = get_person || Person.new
    setup_campuses
    
    
    # if possible prevent the user from having to select a campus    
    session[:signup_campus_id] ||= params[:campus_id] if params[:campus_id]
    session[:signup_campus_id] ||= @primary_campus_involvement.campus_id if @primary_campus_involvement.present?
    
    if session[:signup_campus_id].blank? && cookies[:signup_campus_id] && cookies[:signup_campus_id].to_i.to_s == cookies[:signup_campus_id]
      session[:signup_campus_id] ||= cookies[:signup_campus_id] if Campus.first(:conditions => ["#{Campus._(:id)} = ?", cookies[:signup_campus_id]]).present?
    end
    
    # try to geolocate the campus if we still can't tell where they are
    if session[:signup_campus_id].blank?
      @geo = Autometal::Geoip.new(request.remote_ip)
      campus = Campus.find_nearest_to(@geo.lat, @geo.lng) unless @geo.lat == 0 && @geo.lng == 0
      session[:signup_campus_id] = campus.present? ? campus.id : nil
    end
    
    @semesters = [] << @current_semester << @next_semester
    @ask_campus = session[:signup_campus_id].blank? ? true : false
  end

  def step1_default_group
    get_person
    if @person
      join_default_group(session[:signup_campus_id], params[:semester_id])
    else
      session[:signup_collection_group_semester_id] = params[:semester_id]
    end
    flash[:notice] = "<big>Great! We'll help you find a group that suits you.</big>"
    redirect_to :action => :step2_info
  end

  def step1_group_from_campus

    if params[:primary_campus_involvement_campus_id].blank? || params[:group_semester_id].blank?
      flash[:notice] = "<big>Sorry, we didn't recieve the campus and semester that you chose, please try again.</big>"
      redirect_to :action => :step1_group
      return
    end

    @ministry = Ministry.default_ministry
    get_person
    unless @person
      @me = @my = @person = Person.new
    end
    
    session[:signup_campus_id] = params[:primary_campus_involvement_campus_id]
    @campus = Campus.first(:conditions => {:campus_id => params[:primary_campus_involvement_campus_id]})
    @semester = Semester.first(:conditions => {:semester_id => params[:group_semester_id]})
    @semester = (@semester == @current_semester || @semester == @next_semester) ? @semester : @current_semester
    
    if @campus && @semester
      # use cookie to help reduce the chance that user needs to select a campus
      cookies[:signup_campus_id] = {
        :value => @campus.id,
        :expires => 1.year.from_now.utc
      }
      
      @groups = @campus.groups.find(:all, :conditions => [ "#{Group._(:semester_id)} in (?)", @semester.id ],
                                    :joins => :ministry, :include => { :group_involvements => :person },
                                    :order => "#{Group.__(:name)} ASC")
      
      @semester_filter_options = [ @current_semester, @next_semester ].collect{ |s| [ s.desc, s.id ] }
      @group_types = GroupType.all
      @join = true
      @signup = true
      @campus.ensure_campus_ministry_groups_created
      @collection_group = @campus.collection_groups
      @groups.delete_if { |g| @collection_group.index(g) }
      # cache of campus names
      campuses = Campus.find(:all, :select => "#{Campus._(:id)}, #{Campus._(:name)}", :conditions => [ "#{Campus._(:id)} IN (?)", @groups.collect(&:campus_id).uniq ])
      @campus_id_to_name = Hash[*campuses.collect{ |c| [c.id.to_s, c.name] }.flatten]
    else
      render :update do |page|
        page["#groups"].html "Sorry, something didn't work with the campus or semester that you picked, please try again."
      end
      return
    end
  end


  def step2_info
    @person ||= get_person || Person.new
    @person.email = @group_invitation.recipient_email if @group_invitation
    UserCodesController.clear(session)
    setup_campuses
    @campus = Campus.find(session[:signup_campus_id])
    @dorms ||= @campus.try(:dorms)
    @school_year_id = @person.primary_campus_involvement && @person.primary_campus_involvement.school_year_id
  end

  def get_dorms
    c = Campus.find :first, :conditions => [ "#{Campus._(:id)} = ?", params[:primary_campus_involvement_campus_id] ]
    @dorms = c.try(:dorms)
  end

  def step2_info_submit
    # if no person in params get person from session
    @person = params[:person].present? ? Person.new(params[:person]) : get_person
    @person.email = @group_invitation.recipient_email if @group_invitation
    
    # make sure we have all the right info
    [:email, :first_name, :last_name, :local_phone].each do |c|
      next if c == :email && logged_in?
      @person.errors.add_on_blank(c)
    end
    
    @person.errors.add(:gender, :blank) if @person.gender.blank? || @person.gender == Gender::UNKNOWN
    
    # verify email
    email = @person && @person.email
    if email.present?
      email_error = "Please enter a valid email address. If the email is already in the Pulse, enter it anyways and a verification email will be sent."
      begin
        if !ValidatesEmailFormatOf::validate_email_format(email).nil? || email.length < 6 || email.length > 40
          @person.errors.add_to_base(email_error)
        end
      rescue
        @person.errors.add_to_base(email_error)
      end
    end

    school_year_id = (params[:primary_campus_involvement] && params[:primary_campus_involvement][:school_year_id]) ||
                     @person.primary_campus_involvement.school_year_id
    @primary_campus_involvement = CampusInvolvement.new :school_year_id => school_year_id, :campus_id => session[:signup_campus_id]
    [:campus_id, :school_year_id].each do |c|
      unless @primary_campus_involvement.send(c).present?
        @person.errors.add(c, :blank)
      end
    end

    if @person.errors.present?
      @dorms = @primary_campus_involvement.try(:campus).try(:dorms)
      step2_info
      render :action => "step2_info"
    else
      
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

      if !logged_in? && !session[:code_valid_for_user_id] && !(@user.just_created && @person.just_created) && !session[:signup_group_invitation_id]
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
        joingroups_from_hash(session[:signup_groups], @group_invitation)
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
    flash[:notice] = "<big>Your email has been verified, thanks!</big>"
    redirect_to params.merge(:action => :step2_info_submit)
  end


  def step3_timetable_submit
    flash[:notice] = nil
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])
    @user = @person.user
    link = @user.find_or_create_user_code.callback_url(base_url, "signup", "timetable")
    UserMailer.send_later(:deliver_signup_finished_email, @person.email, link, session[:joined_collection_group]) unless session[:sent_timetable_email] == true
    session[:sent_timetable_email] = true # make sure we don't notify people twice this session
    
    @group = Group.first(:conditions => {:id => session[:signup_joined_group_id]}) if session[:signup_joined_group_id].present?
    @leaders = @group.group_involvements.select{|gi| gi.requested != true && gi.level == Group::LEADER } if @group.present?
    
    if session[:from_facebook_canvas] == true
      @finished_button_text = "Goto Facebook"
    elsif logged_in?
      @finished_button_text = "Goto the dashboard"
    else
      @finished_button_text = nil
    end
  end


  def finished
    @signup = true
    params[:person_id] = session[:signup_person_id]
    @me = @my = @person = Person.find(session[:signup_person_id])
    session[:signup_group_invitation_id] = nil

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
    @custom_userbar_title = "Join a Group" unless logged_in? || session[:from_facebook_canvas] == true
  end

  def join_default_group(campus_id, semester_id)
    throw "join_group requires @person" unless @person
    @campus = Campus.find campus_id

    semester = semester_id.present? ? Semester.find(semester_id) : Semester.current

    # Special case - add them to the Bible study group by default
    gt = GroupType.find_by_group_type GroupType::DG

    @group = @campus.find_or_create_ministry_group gt, nil, semester
    unless GroupInvolvement.first(:conditions => {:person_id => @person.id, :group_id => @group.id}).present? # make sure we don't notify people twice 
      gi = @group.group_involvements.find_or_create_by_person_id_and_level @person.id, 'member'
      gi.send_later(:join_notifications, base_url)
    end
    session[:signup_joined_group_id] = @group.id
    session[:joined_collection_group] = true
  end

  def joingroups_from_hash(involvement_info, invitation = nil)
    (involvement_info || {}).each_pair do |group_id, level|
      if %w(member interested).include?(level)
        group = Group.find group_id
        requested = (level == "member" ? group.needs_approval : false) unless invitation && group_id == invitation.group_id
        
        gi = GroupInvolvement.first(:conditions => {:person_id => @person.id, :group_id => group_id, :level => level, :requested => requested})
        unless gi.present? # make sure we don't notify people twice 
          gi = GroupInvolvement.create_group_involvement(@person.id, group_id, level, requested)
          gi.send_later(:join_notifications, base_url)
        end
        
        session[:signup_joined_group_id] = gi.group_id
        session[:joined_collection_group] = nil
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
      end
    end
  end
end



