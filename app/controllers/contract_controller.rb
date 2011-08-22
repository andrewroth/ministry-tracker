class ContractController < ApplicationController
  unloadable
  
  skip_before_filter :force_required_data, :only => [:volunteer_agreement, :sign_volunteer_contract]

  
  def volunteer_agreement
    @contract = find_next_unsigned_volunteer_contract(@my.id)
    
    if @contract.nil?
      redirect_to :action => "index", :controller => "dashboard"
    else
      @contract_signature = ContractSignature.new(:contract_id => @contract.id)
    end
  end
  

  def sign_volunteer_contract
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
        flash[:notice] = "<big>You're done signing, thanks!</big>"
        redirect_to :action => "index", :controller => "dashboard"
      else
        redirect_to :action => "volunteer_agreement"
      end
      
    else
      @contract = Contract.find(params[:contract_signature]["contract_id"].to_i)
      render :action => "volunteer_agreement"
    end
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
end
