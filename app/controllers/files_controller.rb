# DELETE CANDIDATE
# All commented out. Necessary to preserve?
class FilesController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry, :force_required_data, :only => :progress
  
  # def progress
  #   render :update do |page|
  #     @status = Mongrel::Uploads.check(params[:upload_id])
  #     page.upload_progress.update(@status[:size], @status[:received]) if @status
  #   end
  # end
  # # 
  # # def upload
  # #   if params[:person] && params[:id]
  # #     @person = Person.find(params[:id])
  # #       @person.image = params[:person][:image]
  # #       @person.save(false)
  # #       responds_to_parent do 
  # #       render :update do |page|
  # #         page.call 'UploadProgress.finish'
  # #         page['progress-bar'].replace_html ''
  # #         page[:profileImageBox].replace_html :partial => 'people/image'
  # #         hide_spinner(page)
  # #       end
  # #     end
  # #   else
  # #     render :text => %(<script type="text/javascript">window.parent.UploadProgress.finish();</script>)
  # #   end
  # # end

end
