class TermsController < ApplicationController

  def edit
    @term = Term.find(params[:id])

    respond_to do |format|
      format.js
    end
  end
  
  # POST /terms
  # POST /terms.xml
  def create
    @term = Term.new(params[:term])

    respond_to do |format|
      if @term.save
        flash[:notice] = 'Term was successfully created.'
        format.html { redirect_to(@term) }
        format.xml  { render :xml => @term, :status => :created, :location => @term }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /terms/1
  # PUT /terms/1.xml
  def update
    @id = params[:id]
    @term = Term.find(@id)

    respond_to do |format|
      if @term.update_attributes(params[:term][@id])
        flash[:notice] = 'Term was successfully updated.'
        format.xml  { head :ok }
        format.js
      else
        format.xml  { render :xml => @term.errors, :status => :unprocessable_entity }
        format.js   { render :action => 'edit' }
      end
    end
  end

  # DELETE /terms/1
  # DELETE /terms/1.xml
  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    respond_to do |format|
      format.html { redirect_to(terms_url) }
      format.js 
      format.xml  { head :ok }
    end
  end
end
