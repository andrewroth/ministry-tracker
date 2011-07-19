class GroupInvitationsController < ApplicationController
  unloadable
  
  group_invitation_authentication :only => [:accept, :decline, :list]
  before_filter :get_and_check_invitation, :only => [:accept, :decline, :list]
  
  ALREADY_INVOLVED_MSG = "is already involved in this group so the invitation was not sent"
  ALREADY_INVITED_MSG = "has already been invited to this group so the invitation was not sent"
  INVITATION_SENT_MSG = "was sent an invitation!"
  INVALID_EMAIL_MSG = "appears to be an invalid email address so the invitation was not sent"
  
  
  def new
    @group = Group.find(params[:group_id].to_i)
    @group_invitation = GroupInvitation.new({:group_id => params[:group_id].to_i})
    
    unless @group && (@group.leaders | @group.co_leaders).include?(@me)
      flash[:notice] = "<big>Sorry but you need to be a leader or co-leader of the group to send invitations.</big>"
      redirect_to dashboard_url
      return
    end
    
    respond_to do |format|
      format.html
    end
  end
  
  
  def create_multiple
    @group = Group.find(params[:group_id])
    if @group && (@group.leaders | @group.co_leaders).include?(@me) && params[:group_invitations].present?
      
      flash[:notice] = ""
      params[:group_invitations].each do |id, hash|
        email = hash[:email]

        # check if the email has been invited to this group already
        already_invited = GroupInvitation.all(:conditions => {:recipient_email => email, :group_id => @group.id, :accepted => nil}).empty? ? false : true  # :accepted => nil means the haven't responded to the invite

        # check if the person is already involved in this group
        user = User.find_by_email(email).first
        recipient_person = user.person if user.present?
        if recipient_person.present?
          already_involved = @group.is_associated(recipient_person) && !@group.is_interested(recipient_person) ? true : false
        end
        
        # check if valid email
        valid_email = ValidatesEmailFormatOf::validate_email_format(email).nil? ? true : false
        
        if !valid_email
          flash[:notice] += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> #{email} #{INVALID_EMAIL_MSG} <br/>"
        elsif already_involved
          flash[:notice] += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> #{email} #{ALREADY_INVOLVED_MSG} <br/>"
        elsif already_invited
          flash[:notice] += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> #{email} #{ALREADY_INVITED_MSG} <br/>"
        else
          invitation = GroupInvitation.new({:group_id => @group.id, :recipient_email => email, :sender_person_id => @my.id})
          invitation.recipient_person_id = recipient_person.id if recipient_person.present?
          invitation.save!
          invitation.login_code.expires_at = 2.months.from_now
          invitation.login_code.save!
          invitation.send_later(:send_invite_email, base_url)
          flash[:notice] += "<img src='/images/silk/accept.png' style='vertical-align:middle;'> #{email} #{INVITATION_SENT_MSG} <br/>"
        end
      end
      
    elsif !(@group.leaders | @group.co_leaders).include?(@me)
      flash[:notice] = "Sorry but you need to be a leader or co-leader of this group to send invitations."
    elsif !params[:group_invitations].present?
      flash[:notice] = "Oops! We didn't catch which emails you want to send invites to, please go back and try again."
    elsif !@group
      flash[:notice] = "Oops! We didn't catch which group you want to send invites for, please go back and try again."
    end
    
    
    respond_to do |format|
      format.html { redirect_to group_url(@group) }
    end
  end
  
  
  def accept
    session[:signup_group_invitation_id] = @invitation.id
    flash[:notice] = "<big>Great! Welcome to your group, #{@invitation.group.name}</big>"
    
    # don't actually accept invitation until join a group process is done
    
    # setup the group to join
    session[:signup_groups] ||= {}
    session[:signup_groups][@invitation.group_id] = GroupInvitation::GROUP_INVITE_LEVEL
    session[:signup_campus_id] = @invitation.group.campus.id
    
    if logged_in?
      redirect_to :controller => :signup, :action => :step2_info_submit
    else
      redirect_to :controller => :signup, :action => :step2_info
    end
  end
  
  
  def decline
    @invitation.decline
    
    UserMailer.send_later(:deliver_group_invitation_decline, @invitation, base_url)
    
    session[:signup_group_invitation_id] = @invitation.id
    flash[:notice] = "<big>Okay, you've declined the invite to join #{@invitation.group.name}</big><br/><br/>Maybe you're looking for a different group? Check out other groups at #{@invitation.group.campus.name} below..."
    
    redirect_to :controller => :signup, :action => :step1_group, :campus_id => @invitation.group.campus_id
  end
  
  
  def list # take advantage of the login_code to authenticate a user and find their campus, even though signup doesn't require authentication
    session[:signup_group_invitation_id] = @invitation.id
    redirect_to :controller => :signup, :action => :step1_group, :campus_id => @invitation.group.campus_id
  end


  private
  
  def get_and_check_invitation
    @invitation = GroupInvitation.first(:conditions => {:login_code_id => session[:login_code_id], :id => params[:id], :group_id => params[:group_id]})
    
    if @invitation.blank? || @invitation.has_response?
      if @invitation.present? && @invitation.has_response?
        flash[:notice] = "<big>This invitation has already been responded to.<br/><br/>If this is a mistake we'd still love you to join, so go ahead and click JOIN A GROUP below to find your group and join!</big>"
      else
        flash[:notice] = "<big>We're sorry, something went wrong with your group invitation.<br/><br/>We'd still love you to join though, so go ahead and click JOIN A GROUP below to find your group and join!</big>"
      end
      access_denied(true)
      return
    end
    
    # get person if they exist in DB
    if @invitation.recipient_person_id.present? || User.find_by_email(@invitation.recipient_email).present?
      @person = Person.first(:conditions => {:person_id => @invitation.recipient_person_id}) || User.find_by_email(@invitation.recipient_email).first.person
      # log this person in
      session[:user] = @person.user.id if @person.user 
      login_from_session
    end
  end
end





