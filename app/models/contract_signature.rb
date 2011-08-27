class ContractSignature < ActiveRecord::Base
  
  belongs_to :contract
  belongs_to :person
  
  validates_presence_of :person_id
  validates_presence_of :contract_id
  validates_presence_of :signature, :message => "can't be blank, please type in your name as your signature"
  validates_presence_of :agreement, :message => "must be checked, please check the box to indicate your agreement"
  
end
