# Question: I think there are customisable views, and this controls the columns
# to be included for a given view?
#
class ViewColumnsController < ApplicationController
  # POST /view_columns
  # POST /view_columns.xml
  def create
    @view_column = ViewColumn.new(params[:view_column])
    @view_column.view_id = params[:view_id] 
    @view_column.column_id = params[:column_id] if params[:column_id]

    respond_to do |format|
      if @view_column.save
        format.xml  { head :created, :location => view_column_url(@view_column) }
        format.js
      else
        @view = View.find(params[:view_id])
        format.xml  { render :xml => @view_column.errors.to_xml }
        format.js   { redirect_to edit_view_path(@view) }
      end
    end
  end

  # DELETE /view_columns/1
  # DELETE /view_columns/1.xml
  def destroy
    @view_column = ViewColumn.find(params[:id])
    @view = @view_column.view
    @view_column.destroy

    respond_to do |format|
      format.html { redirect_to view_columns_url }
      format.xml  { head :ok }
      format.js
    end
  end
end
