class DormsController < ApplicationController
  def list
    @dorms = Dorm.find(:all, :conditions => ["#{_(:campus_id, :dorm)} = ?", params[:campus_id]])
    render :partial => 'list'
  end
end