class AccountadminUsersController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_users
  # GET /accountadmin_users.xml
  def index
    @search = params[:search]
    @users = User.search(params[:search], params[:page], params[:per_page]) if @search

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def search
    @search = params[:search]
    @users = User.search(params[:search], params[:page], params[:per_page]) if @search

    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          # 'page.replace' will replace full "results" block...works for this example
          # 'page.replace_html' will replace "results" inner html...useful elsewhere
          page.replace 'users', :partial => 'users'
        end
      }
    end
  end

  # GET /accountadmin_users/1
  # GET /accountadmin_users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /accountadmin_users/new
  # GET /accountadmin_users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /accountadmin_users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /accountadmin_users
  # POST /accountadmin_users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      @user.guid = params[:user][:guid]
      @user.accountgroup_id = params[:user][:accountgroup_id]
      @user.viewer_userID = params[:user][:username]
      @user.language_id = params[:user][:language_id]
      @user.viewer_isActive = params[:user][:is_active]
      @user.viewer_lastLogin = params[:user][:last_login]
      @user.remember_token = params[:user][:remember_token]
      @user.remember_token_expires_at = params[:user][:remember_token_expires_at]
      @user.email_validated = params[:user][:email_validated]
      @user.developer = params[:user][:developer]
      @user.facebook_hash = params[:user][:facebook_hash]
      @user.facebook_username = params[:user][:facebook_username]

      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(accountadmin_user_path(@user)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_users/1
  # PUT /accountadmin_users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      @user.guid = params[:user][:guid]
      @user.accountgroup_id = params[:user][:accountgroup_id]
      @user.viewer_userID = params[:user][:username]
      @user.language_id = params[:user][:language_id]
      @user.viewer_isActive = params[:user][:is_active]
      @user.viewer_lastLogin = params[:user][:last_login]
      @user.remember_token = params[:user][:remember_token]
      @user.remember_token_expires_at = params[:user][:remember_token_expires_at]
      @user.email_validated = params[:user][:email_validated]
      @user.developer = params[:user][:developer]
      @user.facebook_hash = params[:user][:facebook_hash]
      @user.facebook_username = params[:user][:facebook_username]
      
      if @user.save
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(accountadmin_user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_users/1
  # DELETE /accountadmin_users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      if @user.errors.empty?
        flash[:notice] = 'User was successfully deleted.'
      else
        flash[:notice] = "WARNING: Couldn't delete user because:"
        @user.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
      end

      format.html { redirect_to(accountadmin_users_url) }
      format.xml  { head :ok }
    end
  end


  private

  def get_users_from_query(search_query)
    if search_query then


      User.all(:joins => :accountadmin_accountgroup,
               :limit => User::MAX_SEARCH_RESULTS,
               :conditions => ["#{_(:username, :user)} like ? " +
                               "or #{_(:guid, :user)} like ? " +
                               "or #{_(:viewer_id, :user)} like ? " +
                               "or #{_(:english_value, :accountadmin_accountgroup)} like ? ",
                               "%#{search_query}%", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%"])
    else
      nil
    end
  end

end
