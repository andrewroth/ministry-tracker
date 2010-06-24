class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Campus

  has_many :groups
  has_many :campus_ministry_groups
  has_many :collection_groups, :through => :campus_ministry_groups, :class_name => "Group", :source => :group

  # TODO: if we ever support multiple root ministries in one install, ex. AIA and C4C
  # and IV, then Ministry.default_ministry will have to be changed to all "root" ministries
  def ensure_campus_ministry_groups_created(ministries = [ Ministry.default_ministry ])
    ministries.each do | ministry|
      ministry.group_types.each do |gt|
        if gt.has_collection_groups
          cmg = CampusMinistryGroup.find :first, :conditions => [ 
          "#{_(:campus_id, :campus_ministry_group)} = ? AND #{_(:ministry_id, :campus_ministry_group)} = ?", self.id, ministry.id ]
          if cmg
            group = cmg.group
          else
            group = gt.groups.new :campus_id => self.id
          end
          group.derive_name
          group.save!

          cmg ||= CampusMinistryGroup.create! :campus => self, :ministry => ministry, :group => group
        end
      end
    end
  end
end
