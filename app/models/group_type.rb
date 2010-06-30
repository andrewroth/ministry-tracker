class GroupType < ActiveRecord::Base
  load_mappings
  belongs_to :ministry
  has_many :groups
  validates_presence_of :group_type, :ministry_id
  after_save :update_collection_groups

  def collection_groups
    groups.find(:all, :joins => :campus_ministry_group, 
                :conditions => [ "campus_ministry_groups.id is not null" ])
   end

  def update_collection_groups
    if has_collection_groups
     # TODO: if we ever support multiple root ministries in one install, ex. AIA and C4C
      # and IV, then Ministry.default_ministry will have to be changed to all "root" ministries
      collection_groups.each do |cg|
        cg.derive_name(collection_group_name)
        cg.derive_ministry
        cg.save!
      end
    end
  end
end
