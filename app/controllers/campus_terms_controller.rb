class CampusTermsController < ApplicationController
  # GET /campus_terms
  # GET /campus_terms.xml
  def index
    @campus_terms = CampusTerm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campus_terms }
    end
  end

  # GET /campus_terms/1
  # GET /campus_terms/1.xml
  def show
    @campus_term = CampusTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @campus_term }
    end
  end

  # GET /campus_terms/new
  # GET /campus_terms/new.xml
  def new
    @campus_term = CampusTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @campus_term }
    end
  end

  # GET /campus_terms/1/edit
  def edit
    @campus_term = CampusTerm.find(params[:id])
  end

  # POST /campus_terms
  # POST /campus_terms.xml
  def create
    @campus_term = CampusTerm.new(params[:campus_term])

    respond_to do |format|
      if @campus_term.save
        flash[:notice] = 'CampusTerm was successfully created.'
        format.html { redirect_to(@campus_term) }
        format.xml  { render :xml => @campus_term, :status => :created, :location => @campus_term }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @campus_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /campus_terms/1
  # PUT /campus_terms/1.xml
  def update
    @campus_term = CampusTerm.find(params[:id])

    respond_to do |format|
      if @campus_term.update_attributes(params[:campus_term])
        flash[:notice] = 'CampusTerm was successfully updated.'
        format.html { redirect_to(@campus_term) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @campus_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /campus_terms/1
  # DELETE /campus_terms/1.xml
  def destroy
    @campus_term = CampusTerm.find(params[:id])
    @campus_term.destroy

    respond_to do |format|
      format.html { redirect_to(campus_terms_url) }
      format.xml  { head :ok }
    end
  end
end
