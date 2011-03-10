class NoticesController < ApplicationController
  layout "manage"

  # GET /notices
  def index
    @notices = Notice.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /notices/1
  def show
    @notice = Notice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /notices/new
  def new
    @notice = Notice.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /notices/1/edit
  def edit
    @notice = Notice.find(params[:id])
  end

  # POST /notices
  def create
    @notice = Notice.new(params[:notice])

    respond_to do |format|
      if @notice.save
        flash[:notice] = 'Notice was successfully created.'
        format.html { redirect_to(@notice) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /notices/1
  def update
    @notice = Notice.find(params[:id])

    respond_to do |format|
      if @notice.update_attributes(params[:notice])
        flash[:notice] = 'Notice was successfully updated.'
        format.html { redirect_to(@notice) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /notices/1
  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy

    respond_to do |format|
      format.html { redirect_to(notices_url) }
    end
  end

  def dismiss
    @notice = Notice.find(params[:id])
    @my.dismissed_notices.find_or_create_by_notice_id(@notice.id)
  end
end
