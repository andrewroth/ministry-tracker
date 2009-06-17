class MinistrySchoolYearsController < ApplicationController

  def new
    @ministry_school_year = MinistrySchoolYear.new()
    
    respond_to do |format|
      format.html 
      format.js
      format.xml  { render :xml => @ministry_school_year }
    end
  end
  
  def edit
    @ministry_school_year = MinistrySchoolYear.find(params[:id])
    
    respond_to do |format|
      format.html
      format.js
      format.xml  { render :xml => @ministry_school_year }
    end
  end
  
  # POST /ministry_school_years
  # POST /ministry_school_years.xml
  def create
    @ministry_school_year = MinistrySchoolYear.new(params[:ministry_school_year])
    @ministry_school_year.ministry ||= @ministry
    
    respond_to do |format|
      if @ministry_school_year.save
        flash[:notice] = 'MinistrySchoolYear was successfully created.'
        format.html { render :action => "edit", :object => @ministry_school_year }
        format.js { render :action => "edit", :object => @ministry_school_year }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @ministry_school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ministry_school_years/1
  # PUT /ministry_school_years/1.xml
  def update
    @ministry_school_year = MinistrySchoolYear.find(params[:id])

    respond_to do |format|
      if @ministry_school_year.update_attributes(params[:ministry_school_year])
        flash[:notice] = 'MinistrySchoolYear was successfully updated.'
        format.html { redirect_to(@ministry_school_year) }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :action => "update" }
        format.xml  { render :xml => @ministry_school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ministry_school_years/1
  # DELETE /ministry_school_years/1.xml
  def destroy
    @ministry_school_year = MinistrySchoolYear.find(params[:id])
    @ministry_school_year.destroy

    respond_to do |format|
      format.html { redirect_to(ministry_school_years_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_new_term
    @ministry_school_year = MinistrySchoolYear.find(params[:id])
    @term = Term.new
    
    @ministry_school_year.terms << @term

    respond_to do |format|
      format.html { render :action => "edit" }
      format.js   { }
      format.xml  { render :xml => @ministry_school_year.errors, :status => :unprocessable_entity }
    end
  end
end
