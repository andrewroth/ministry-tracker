class MinistryInvolvement < ActiveRecord::Base
  load_mappings
  include Common::Core::MinistryInvolvement
  include Common::Core::Ca::MinistryInvolvement

  after_save :check_for_nil_role
    
  private

  def check_for_nil_role
    Rails.logger.info("Detected nil ministry_role_id on involvement #{self.id}") if self.ministry_role_id.nil?
  end

end
