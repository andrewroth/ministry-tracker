module PersonMethodsEmu

  def database_conditions(params)
    special_conditions = {}
    
    if params[:gender] == 1
      special_conditions[:gender] = "Person.gender_id IN('1')"
    else
      special_conditions[:gender] = "Person.gender_id IN('2')"
    end
    special_conditions[:school_year] = "PersonYear.year_id IN(#{quote_string(params[:school_year].join(','))})"    
    special_conditions[:email] = "Person.person_email = '#{quote_string(params[:email])}'"
    special_conditions
  end
  
  def add_person(person, current_address, params)
    # ===============================================
    # = Check for duplicate person. VERY IMPORTANT! =
    # ===============================================
    
    exact = Person.find_user(person, current_address)
    # similar = Person.find_similar(person, current_address)
    if exact
      # Get rid of empty values (so we don't wipe out values in our update_attributes call)
      params[:person].delete_if {|key, value| value && value.strip == "" } 
      params[:current_address].delete_if {|key, value| value && value.strip == "" } 
      
      person = exact
      # Update the person's name and address
      person.update_attributes(params[:person]) 
      person.current_address.update_attributes(params[:current_address])
      #if person.current_address 
       # person.current_address.update_attributes(params[:current_address])
      #else
       # person.current_address = current_address
      #end
    else
      person.created_by = 'MT'
      person.updated_by = 'MT'
      # manually set these because with the custom column mapping RAILS doesn't always set them automatically
      person.created_at = Time.now
      person.updated_at = Time.now
      person.save!
      # add address
      person.current_address.update_attributes(params[:current_address])
      person.current_address.save!
    end
    current_address = person.current_address
    person.create_user_and_access_only("", current_address.person_email) if  person.user.nil?
    return person, current_address
  end
  
end