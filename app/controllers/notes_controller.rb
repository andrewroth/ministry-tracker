class NotesController < ApplicationController

  def create
    @noteable = find_noteable
    @note = @noteable.notes.build(params[:note])
    @note.person_id = get_person.try(:id)
    
    if @note.save
      flash[:notice] = "Note added!"
      redirect_to @noteable
    else
      redirect_to :back
    end
  end

  private

  def find_noteable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
