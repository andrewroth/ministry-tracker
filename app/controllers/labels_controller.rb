class LabelsController < ApplicationController
  layout "manage"

  def index
    @labels = Label.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @label = Label.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @label = Label.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @label = Label.find(params[:id])
  end

  def create
    @label = Label.new(params[:label])

    respond_to do |format|
      if @label.save
        flash[:notice] = 'Label was successfully created.'
        format.html { redirect_to(@label) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @label = Label.find(params[:id])

    respond_to do |format|
     if @label.update_attributes(params[:label])
        flash[:notice] = 'Label was successfully updated.'
        format.html { redirect_to(@label) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy

    respond_to do |format|
      format.html { redirect_to(labels_url) }
    end
  end
end
