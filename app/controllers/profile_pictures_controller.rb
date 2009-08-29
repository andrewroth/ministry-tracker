# CRUD for profile pictures
class ProfilePicturesController < ApplicationController
  
  # POST /profile_pictures
  # POST /profile_pictures.xml
  def create
    @profile_picture = ProfilePicture.new(params[:profile_picture])
    @profile_picture.person = @person
    flash[:notice] = 'Profile Picture was successfully created.' if @profile_picture.valid? && @profile_picture.save!
    respond_to do |format|
      format.html do
        redirect_to(@person) 
      end
    end
  end

  # PUT /profile_pictures/1
  # PUT /profile_pictures/1.xml
  def update
    @profile_picture = ProfilePicture.find(params[:id])
    if @profile_picture.update_attributes(params[:profile_picture])
      flash[:warning] = 'Profile Picture was successfully updated.'
      respond_to do |format|
        format.html { redirect_to(@profile_picture.person) }
        format.xml  { render :xml => @profile_picture.to_xml}
      end
    else
      flash[:warning] = 'There was a problem updating your profile picture.'
      respond_to do |format|
        format.html { redirect_to(@profile_picture.person) }
        format.xml  { render :xml => @profile_picture.errors, :status => :unprocessable_entity }
      end
    end
  rescue Errno::ECONNREFUSED # Catch an S3 error
    flash[:warning] = 'There was a problem updating your profile picture. Please try again.'
    respond_to do |format|
      format.html { redirect_to(@profile_picture.person) }
      format.xml  { render :xml => @profile_picture.errors, :status => :unprocessable_entity }
    end
  end
  
    
  def destroy
    if params[:id]
      @profile_picture = ProfilePicture.find(params[:id], :include => :person)
      @profile_picture.destroy
      @person = @profile_picture.person
      @profile_picture = ProfilePicture.new(:person_id => @person.id)
	  end
    respond_to do |format|
      format.js do
	      render :update do |page|
	        page[:uploadPicture].replace :partial => 'people/upload_picture'
  	      page[:profileImageBox].replace_html :partial => 'people/image'
  	      hide_spinner(page)
        end
      end
    end
  rescue Errno::ECONNREFUSED # Catch an S3 error
    respond_to do |format|
      format.js do
	      render :update do |page|
	        page.alert('There was a problem updating your profile picture. Pleasee try again.')
  	      hide_spinner(page)
        end
      end
    end
  end
end
