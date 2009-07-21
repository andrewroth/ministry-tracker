module PersonMethods
  def database_search_conditions(params)
    special_conditions = Hash.new
    special_conditions[:gender] = "Person.#{_(:gender, :person)} IN(#{quote_string(params[:gender].join(','))})" if params[gender].present?
    special_conditions[:school_year] = "CampusInvolvement.#{_(:school_year_id, :campus_involvement)} IN(#{quote_string(params[:school_year].join(','))})" if params[gender].present?   
    special_conditions[:email] = "CurrentAddress.#{_(:email, :address)} = '#{quote_string(params[:email])}'" if params[gender].present?
    special_conditions
  end
  
  
  
  def add_person(person, current_address, params)
    # ===============================================
    # = Check for duplicate person. VERY IMPORTANT! =
    # ===============================================
    exact = Person.find_exact(person, current_address)
    # similar = Person.find_similar(person, current_address)
    if exact
      # Get rid of empty values (so we don't wipe out values in our update_attributes call)
      params[:person].delete_if {|key, value| value && value.strip == "" } 
      params[:current_address].delete_if {|key, value| value && value.strip == "" } 
      
      person = exact
      # Update the person's name and address
      person.update_attributes(params[:person])
      if person.current_address 
        person.current_address.update_attributes(params[:current_address])
      else
        person.current_address = current_address
      end
      current_address = person.current_address
      @msg = "Person already exists. Person was updated and added to your ministry."
    else
      person.created_by = 'MT'
      person.updated_by = 'MT'
      # manually set these because with the custom column mapping RAILS doesn't always set them automatically
      person.created_at = Time.now
      person.updated_at = Time.now
      person.save!
      # add address
      person.current_address = current_address
      current_address.save!
    end
    person.user ||= User.new(:username => current_address.email) 
    person.user.save(false)
    person.save(false)
    return person, current_address
  end
end