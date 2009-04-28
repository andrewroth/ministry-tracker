class CorrespondencesController < ApplicationController
  layout 'manage'
  # GET /correspondences
  # GET /correspondences.xml
  def index
    @correspondences = Correspondence.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @correspondences }
    end
  end

  # GET /correspondences/1
  # GET /correspondences/1.xml
  def show
    @correspondence = Correspondence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @correspondence }
    end
  end


  # DELETE /correspondences/1
  # DELETE /correspondences/1.xml
  def destroy
    @correspondence = Correspondence.find(params[:id])
    @correspondence.destroy

    respond_to do |format|
      format.html { redirect_to(correspondences_url) }
      format.xml  { head :ok }
    end
  end

  # GET /correspondences/1/rcpt
  def rcpt
    @correspondence = Correspondence.find(:first, :conditions => { :receipt => params[:id]})

    respond_to do |format|
      if @correspondence
        # record this visit, overriding any existing visits
        @correspondence.record_visit
        # redirect user to stored redirect uri
        format.html { redirect_to(@correspondence.redirect_params) }
        format.xml  { head :ok }
      else
        flash[:warning] = 'The receipt you supplied is invalid.'
        format.html { redirect_to(:controller => "dashboard") }
        format.xml  { render :xml => @correspondence_type.errors, :status => :unprocessable_entity }
      end
    end

  end

  # GET /correspondences/processqueue
  def processqueue
    Correspondence.processQueue
    flash[:notice] = "The queue has been processed."
    redirect_to(:action => "index")
  end
end
