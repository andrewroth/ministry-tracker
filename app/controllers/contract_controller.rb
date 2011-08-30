class ContractController < ApplicationController
  unloadable
  
  skip_before_filter :force_required_data, :only => [:volunteer_agreement, :sign_volunteer_contract, :decline_volunteer_contract]
  layout :get_layout
  
  def volunteer_agreement
    unless needs_to_sign_volunteer_agreements?
      redirect_to :action => "index", :controller => "dashboard"
      return
    end
    
    @contract = find_next_unsigned_volunteer_contract(@my.id)
    
    case @contract.id
    when Contract::VOLUNTEER_CONTRACT_IDS.first
      flash[:notice] = "<p><big>Hi #{@my.first_name}!</big></p><p>We're excited that you're volunteering as a leader with Power to Change this school year.</p><p>As you know, Power to Change seeks to glorify God by making a maximum contribution toward helping to fulfil the Great Commission in Canada and around the world by developing movements of evangelism and discipleship. It's to this end that Volunteer leaders are expected to live a life that is above reproach and consistent with biblical standards.</p><p>As a Volunteer leader for this school year, please take some time to carefully read through the following three agreements and sign each one by typing in your name. Volunteer leaders are required to sign this each year. The first agreement is #{@contract.title}.</p>"
    when Contract::VOLUNTEER_CONTRACT_IDS[1]
      flash[:notice] = "<p>The second agreement is #{@contract.title}.</p><p>Please carefully read through it and sign at the bottom by typing in your name.</p>"
    when Contract::VOLUNTEER_CONTRACT_IDS.last
      flash[:notice] = "<p>You're almost done, the last agreement is #{@contract.title}.</p><p>Again, please carefully read through it and sign at the bottom by typing in your name.</p>"
    end
    
    if @contract.nil?
      redirect_to :action => "index", :controller => "dashboard"
    else
      @contract_signature = ContractSignature.new(:contract_id => @contract.id)
    end
  end
  

  def sign_volunteer_contract
    unless needs_to_sign_volunteer_agreements?
      redirect_to :action => "index", :controller => "dashboard"
      return
    end
    
    if params[:contract_signature].blank? || 
       params[:contract_signature]["contract_id"].blank? || 
       Contract.all(:conditions => {:id => params[:contract_signature]["contract_id"].to_i}).blank?
       
      redirect_to :action => "volunteer_agreement"
      return
    end
    
    @contract_signature = ContractSignature.new(params[:contract_signature])
    @contract_signature.person_id = @my.id
    @contract_signature.signed_at = Time.now
    
    if @contract_signature.save
      next_contract = find_next_unsigned_volunteer_contract(@my.id)
      
      if next_contract.nil?
        flash[:notice] = "<big>Great, you're done signing the agreements, thanks!</big>"
        redirect_to :action => "index", :controller => "dashboard"
      else
        redirect_to :action => "volunteer_agreement"
      end
      
    else
      @contract = Contract.find(params[:contract_signature]["contract_id"].to_i)
      render :action => "volunteer_agreement"
    end
  end
  
  
  def decline_volunteer_contract
    unless is_staff_somewhere
      student_role = StudentRole.find(:first, :conditions => {:name => "Student"})
      @me.add_or_update_ministry(@ministry.id, student_role.id)
      flash[:notice] = "<big>Okay, you've skipped signing the Volunteer leader agreements, please note that you'll no longer be able to perform any Volunteer leader functions.</big>"
    end
    logout_keeping_session!
  end


  def volunteer_agreement_report
    @my_campuses = @my.campuses_under_my_ministries_with_children(MinistryRole.ministry_roles_that_grant_access("contract", "volunteer_agreement_report"))
    
    campus_id = params[:campus_id]
    campus_id = nil unless @my_campuses.detect {|c| c.id == campus_id.to_i }
    campus_id ||= @my_campuses.first
    
    unless campus_id
      flash[:notice] = "Couldn't load the report because your campus couldn't be found"
      redirect_to :action => "index", :controller => "dashboard"
      return
    end
    
    @campus = Campus.find(campus_id)
    campus_ministry_id = @campus.derive_ministry.id
    
    @roles_requiring_volunteer_agreement = MinistryRole.all - MinistryRole.ministry_roles_that_grant_access("contract", "volunteer_agreement_not_required")
    role_ids_requiring_volunteer_agreement = @roles_requiring_volunteer_agreement.collect {|r| r.id}
    
    people_at_campus_ids = Person.all(:joins => [:campus_involvements], :conditions => {:campus_involvements => {:campus_id => @campus.id}}).collect {|p| p.id}
    
    # find all people at the selected campus who have a role that requires they sign the volunteer agreements
    people = Person.all(:joins => [:ministry_involvements], :conditions => ["#{Person.__(:id)} in (?) and #{MinistryInvolvement.__(:ministry_role_id)} in (?) and #{MinistryInvolvement.__(:ministry_id)} = ?",
      people_at_campus_ids, role_ids_requiring_volunteer_agreement, campus_ministry_id])
    
    @people_who_signed = []
    @people_who_still_need_to_sign = []
    
    people.each do |person|
      if person.signed_volunteer_contract_this_year?
        @people_who_signed << person
      else
        @people_who_still_need_to_sign << person
      end
    end
    
    @current_year = Year.current
  end


  private
  
  def find_next_unsigned_volunteer_contract(person_id)
    contract = nil
    
    Contract::VOLUNTEER_CONTRACT_IDS.each do |contract_id|
      next if ContractSignature.all(:conditions => ["#{ContractSignature._(:person_id)} = ? and 
                                                     #{ContractSignature._(:contract_id)} = ? and 
                                                     #{ContractSignature._(:agreement)} = true and 
                                                     #{ContractSignature._(:signature)} <> '' and 
                                                     #{ContractSignature._(:signed_at)} > ?",
                                                     person_id, contract_id, Year.current.start_date]).present?
      contract = Contract.find(contract_id)
      break
    end
    
    contract
  end
  
  def get_layout
    params[:action] == "volunteer_agreement_report" ? "manage" : "application"
  end
end
