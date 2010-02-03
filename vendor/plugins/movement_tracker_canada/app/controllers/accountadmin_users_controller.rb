class AccountadminUsersController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_users
  # GET /accountadmin_users.xml
  def index
    @query = params[:search][:query] if params[:search]

    @users = get_users_from_query(@query)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def search
    @query = params[:search][:query]

    @users = get_users_from_query(@query)

    respond_to do |format|
      format.js if request.xhr?
      format.html
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
      flash[:notice] = @user.errors.empty? ? 'User was successfully deleted.' : "WARNING: Couldn't delete user because it's " + @user.errors.first.to_s
      format.html { redirect_to(accountadmin_users_url) }
      format.xml  { head :ok }
    end
  end


  private

  def get_users_from_query(search_query)
    users = nil

    if search_query then
      users = User.all(:joins => :accountadmin_accountgroup,
                       :limit => User::MAX_SEARCH_RESULTS,
                       :conditions => ["#{_(:username, :user)} like ? " +
                                       "or #{_(:guid, :user)} like ? " +
                                       "or #{_(:viewer_id, :user)} like ? " +
                                       "or #{_(:english_value, :accountadmin_accountgroup)} like ? ",
                                       "%#{search_query}%", "%#{search_query}%", "%#{search_query}%", "%#{search_query}%"])
    end

    users
  end

end
