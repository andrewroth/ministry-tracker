class CorrespondencesController < ApplicationController
  before_filter :developer_filter

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
end
