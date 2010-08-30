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
          find_or_create_ministry_group(gt)
        end
      end
    end
  end

  def find_or_create_ministry_group(gt, ministry = derive_ministry)
    raise "Group type does not have collection groups" unless gt.has_collection_groups
    if ministry.nil? && (ministry = derive_ministry).nil?
      logger.info "Warning: In Campus.find_or_create_ministry_group and could not derive a ministry for campus #{self.inspect}"
      return
    end

    cmg = campus_ministry_groups.find_by_ministry_id(ministry, :joins => :group,
      :conditions => [ "group_type_id = ?", gt.id ] )
    if cmg
      group = cmg.group
    else
      group = gt.groups.new :campus_id => self.id, :ministry_id => ministry.id
    end
    group.ministry = derive_ministry
    group.derive_name
    group.semester ||= Semester.current
    group.save!

    cmg ||= campus_ministry_groups.create! :ministry => ministry, :group => group
    return group
  end
end
