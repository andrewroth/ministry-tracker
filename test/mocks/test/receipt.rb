class Receipt
  attr_accessor :user_name, :attributes 
  def initialize
    @user_name = 'josh.starcher@uscm.org'
    @attributes = {:ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026',
                   :emplid => '000559826',
                   :firstName => 'Josh',
                   :lastName => 'Starcher'}
  end
  
  def guid
    @attributes[:ssoGuid]
  end
  
  def first_name
    @attributes[:first_name]
  end
end