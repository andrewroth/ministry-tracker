class AccountadminLanguagesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_languages
  # GET /accountadmin_languages.xml
  def index
    @accountadmin_languages = AccountadminLanguage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_languages }
    end
  end

  # GET /accountadmin_languages/1
  # GET /accountadmin_languages/1.xml
  def show
    @accountadmin_language = AccountadminLanguage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accountadmin_language }
    end
  end

  # GET /accountadmin_languages/new
  # GET /accountadmin_languages/new.xml
  def new
    @accountadmin_language = AccountadminLanguage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accountadmin_language }
    end
  end

  # GET /accountadmin_languages/1/edit
  def edit
    @accountadmin_language = AccountadminLanguage.find(params[:id])
  end

  # POST /accountadmin_languages
  # POST /accountadmin_languages.xml
  def create
    @accountadmin_language = AccountadminLanguage.new(params[:accountadmin_language])

    respond_to do |format|
      if @accountadmin_language.save
        flash[:notice] = 'Language was successfully created.'
        format.html { redirect_to(@accountadmin_language) }
        format.xml  { render :xml => @accountadmin_language, :status => :created, :location => @accountadmin_language }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accountadmin_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_languages/1
  # PUT /accountadmin_languages/1.xml
  def update
    @accountadmin_language = AccountadminLanguage.find(params[:id])

    respond_to do |format|
      if @accountadmin_language.update_attributes(params[:accountadmin_language])
        flash[:notice] = 'Language was successfully updated.'
        format.html { redirect_to(@accountadmin_language) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accountadmin_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_languages/1
  # DELETE /accountadmin_languages/1.xml
  def destroy
    @accountadmin_language = AccountadminLanguage.find(params[:id])
    @accountadmin_language.destroy

    respond_to do |format|
      format.html { redirect_to(accountadmin_languages_url) }
      format.xml  { head :ok }
    end
  end
end
