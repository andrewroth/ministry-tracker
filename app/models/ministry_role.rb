class MinistryRole < ActiveRecord::Base
  load_mappings
  include Common::Core::MinistryRole
  include Common::Core::Ca::MinistryRole

  def translation_key() self.name.downcase.gsub(' ','_') end
end
