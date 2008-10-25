class DormsController < ApplicationController
  def create
    @dorm = Dorm.create!(params[:dorm])
  end
  
  def list
    @dorms = Dorm.find(:all, :conditions => ["#{_(:campus_id, :dorm)} = ?", params[:campus_id]])
    render :partial => 'list'
  end
  
  def destroy
    @dorm = Dorm.find(params[:id])
    # Make sure this dorm is in their realm of power
    @dorms = @ministry.campuses.collect(&:dorms).flatten
    if @dorms.include?(@dorm) && is_ministry_leader
      @dorm.destroy
    end
  end
end