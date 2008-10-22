class AuthController < ApplicationController
  # skip_before_filter :check_login, :get_person, :get_ministry
  
  def login
    # # check for cas user
    # if request.username
    #   # first try to find the user based on their guid (best method)
    #   user = User.find(:first, :conditions => [_(:guid, :user) + ' = ?', receipt.guid], :include => :person)
    #   
    #   # next, look for an email address match in the username field.
    #   if !user
    #     user = User.find(:first, :conditions => [_(:username, :user) + ' = ?', request.username], :include => :person)
    #     # if we find a user this way, we need to validate that they own this email address
    #     if user 
    #       # send_email_validation(user.person); return unless user.email_validated?
    #       user.guid = receipt.guid  # the email has already been validated. we're safe.
    #       user.save!
    #     end
    #   end
    #   
    #   # The last thing to check is to look for their email in an address. this is sloppier since more than one person 
    #   # can have the same email address in an address.
    #   if !user
    #     address = CurrentAddress.find(:first, :conditions => [_(:email, :address) + ' = ?', request.username], :include => {:person => :user})
    #     if address
    #       person = address.person
    #     end
    #     # if we happened to find a person this way, validate their email address
    #     if person
    #       # send_email_validation(person); return unless address.email_validated?
    #       # If the email address has already been validated create/update the user
    #       user = person.user
    #       if !user
    #         user = User.new(:username => request.username)
    #         user.person = person
    #       end
    #       user.guid = receipt.guid  
    #       user.save!  
    #     end
    #   end
    # 
    #   session[:logged_in] = true
    #   
    #   if user && user.person
    #     # set the username to the gcx username just in case they changed it.
    #     user.username = request.username
    #     user.save!
    #     #if we have a user in the system already go to their profile
    #     person = user.person
    #     session[:person_id] = person.id
    #     next_page = session[:return_to] ? session[:return_to] : person_url(session[:person_id])
    #     redirect_to next_page
    #   # if the user isn't found, create it
    #   else
    #     render :action => 'no_profile'
    #   end
    # else
    #   # shouldn't get here. 
    #   raise "got to login method with no cas user."
    # end
  end
  
  def perform_login
    if !params[:username] || params[:username].empty? || params[:password].empty?
        flash[:warning] = "You must enter a username and password."
        redirect_to :action => :login
      else
        user = User.authenticate(params[:username], params[:passsword])
        session[:person_id] = user.person.id
        next_page = session[:return_to] ? session[:return_to] : person_url(session[:person_id])
        redirect_to next_page
      end
  end
  
  def logout
    # If the user is logged in, kill the session and send them to the gcx logout
    if session[:logged_in]
      reset_session
      redirect_to CAS::Filter.logout_url(self)
    else
      # if the user isn't logged in, log them in (coming back from a gcx logout)
      perform_login
    end
  end
  
  protected
    def send_email_validation(person)
      render :action => "validation_sent"
    end
end
