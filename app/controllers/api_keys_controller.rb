class ApiKeysController < ApplicationController

  layout 'manage'

  def index
    @api_keys = ApiKey.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @api_key = ApiKey.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @api_key = ApiKey.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @api_key = ApiKey.find(params[:id])
  end

  def create
    user = User.all(:conditions => ["#{User._(:id)} = ? or #{User._(:username)} = ?", params[:api_key][:user_id], params[:api_key][:user_id]]).first
    params[:api_key][:user_id] = user.try(:id)
    
    @api_key = ApiKey.new(params[:api_key])

    respond_to do |format|
      if @api_key.save
        format.html { redirect_to(@api_key, :notice => 'API Key was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    user = User.all(:conditions => ["#{User._(:id)} = ? or #{User._(:username)} = ?", params[:api_key][:user_id], params[:api_key][:user_id]]).first
    params[:api_key][:user_id] = user.try(:id)
    
    @api_key = ApiKey.find(params[:id])

    respond_to do |format|
      if @api_key.update_attributes(params[:api_key])
        format.html { redirect_to(@api_key, :notice => 'API Key was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @api_key = ApiKey.find(params[:id])
    @api_key.login_code.destroy
    @api_key.destroy

    respond_to do |format|
      format.html { redirect_to(api_keys_url) }
    end
  end
end
