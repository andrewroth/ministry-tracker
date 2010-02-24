class GendersController < ApplicationController
  unloadable
  layout 'manage'

  # GET /genders
  # GET /genders.xml
  def index
    @genders = Gender.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genders }
    end
  end

  # GET /genders/1
  # GET /genders/1.xml
  def show
    @gender = Gender.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gender }
    end
  end

  # GET /genders/new
  # GET /genders/new.xml
  def new
    @gender = Gender.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gender }
    end
  end

  # GET /genders/1/edit
  def edit
    @gender = Gender.find(params[:id])
  end

  # POST /genders
  # POST /genders.xml
  def create
    @gender = Gender.new(params[:gender])

    respond_to do |format|
      if @gender.save
        flash[:notice] = 'Gender was successfully created.'
        format.html { redirect_to(@gender) }
        format.xml  { render :xml => @gender, :status => :created, :location => @gender }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /genders/1
  # PUT /genders/1.xml
  def update
    @gender = Gender.find(params[:id])

    respond_to do |format|
      if @gender.update_attributes(params[:gender])
        flash[:notice] = 'Gender was successfully updated.'
        format.html { redirect_to(@gender) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gender.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /genders/1
  # DELETE /genders/1.xml
  def destroy
    @gender = Gender.find(params[:id])
    @gender.destroy

    unless @gender.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete gender because:"
      @gender.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(genders_url) }
      format.xml  { head :ok }
    end
  end
end
