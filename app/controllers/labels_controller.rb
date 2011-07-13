class LabelsController < ApplicationController
  layout "manage"	
  
  # GET /labels
  # GET /labels.xml
  def index
    @labels = Label.all

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @labels }
    end
  end

  # GET /labels/1
  # GET /labels/1.xml
  def show
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @label }
    end
  end

  # GET /labels/new
  # GET /labels/new.xml
  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @label }
    end
  end

  # GET /labels/1/edit
  def edit
    @label = Label.find(params[:id])
  end

  # POST /labels
  # POST /labels.xml
  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      # if @label.save
      #   format.html { redirect_to(@label, :notice => 'Label was successfully created.') }
      #   format.xml  { render :xml => @label, :status => :created, :location => @label }
      # else
      #   format.html { render :action => "new" }
      #   format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      # end
      if @label.save
        flash[:notice] = 'Label was successfully created.'
        format.html { redirect_to(@label) }
      else
        format.html { render :action => "new" }
      end      
    end
  end

  # PUT /labels/1
  # PUT /labels/1.xml
  def update
    @label = Label.find(params[:id])

    respond_to do |format|
      # if @label.update_attributes(params[:label])
      #   format.html { redirect_to(@label, :notice => 'Label was successfully updated.') }
      #   format.xml  { head :ok }
      # else
      #   format.html { render :action => "edit" }
      #   format.xml  { render :xml => @label.errors, :status => :unprocessable_entity }
      # end
     if @label.update_attributes(params[:label])
        flash[:notice] = 'Label was successfully updated.'
        format.html { redirect_to(@label) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /labels/1
  # DELETE /labels/1.xml
  def destroy
    @label = Label.find(params[:id])
    @label.destroy

    respond_to do |format|
      format.html { redirect_to(labels_url) }
      #format.xml  { head :ok }
    end
  end
end
