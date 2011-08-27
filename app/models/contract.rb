class Contract < ActiveRecord::Base
  
  has_many :signatures, :class_name => "ContractSignature"
  has_many :clauses, :class_name => "ContractClause", :order => "#{ContractClause.__(:order)} ASC"
  
  VOLUNTEER_CONTRACT_IDS = [1,2,3]
  
end
