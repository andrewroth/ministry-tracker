class MinistryInvolvement < ActiveRecord::Base
  load_mappings
  
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  belongs_to :ministry
  
  validates_presence_of _(:ministry_role), :on => :create, :message => "can't be blank"
  
  before_validation :set_ministry_role
  
  private
  def set_ministry_role
    if self.ministry_role_id
      begin
        self.ministry_role = MinistryRole.find(self.ministry_role_id).name
      rescue; end
    end
  end
end
