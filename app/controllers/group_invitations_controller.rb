class GroupInvitationsController < ApplicationController
  unloadable
  
  ALREADY_INVOLVED_MSG = "is already involved in this group so the invitation was not sent"
  ALREADY_INVITED_MSG = "has already been invited to this group so the invitation was not sent"
  INVITATION_SENT_MSG = "was sent an invitation"

  def new
    @group = Group.find(params[:group_id].to_i)
    @group_invitation = GroupInvitation.new({:group_id => params[:group_id].to_i})
    @preview_group_invitation = GroupInvitation.new({:group_id => @group.id, :recipient_email => @my.email, :sender_person_id => @my.id})
    
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
        user = User.first(:conditions => ["#{User._(:username)} = ?", email])
        recipient_person = user.person if user.present?
        if recipient_person.present?
          already_involved = @group.is_associated(recipient_person) && !@group.is_interested(recipient_person) ? true : false
        end
        
        if already_involved
          flash[:notice] += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> #{email} #{ALREADY_INVOLVED_MSG} <br/>"
        elsif already_invited
          flash[:notice] += "<img src='/images/silk/exclamation.png' style='vertical-align:middle;'> #{email} #{ALREADY_INVITED_MSG} <br/>"
        else
          invitation = GroupInvitation.new({:group_id => @group.id, :recipient_email => email, :sender_person_id => @my.id})
          invitation.recipient_person_id = recipient_person.id if recipient_person.present?
          invitation.save!
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
  end
  
  def decline
  end
  
end
