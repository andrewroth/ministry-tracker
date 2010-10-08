class Campus < ActiveRecord::Base
  load_mappings
  include Common::Core::Campus
  include Common::Core::Ca::Campus
  include Legacy::Stats::Core::Campus

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

  def find_or_create_ministry_group(gt, ministry = derive_ministry, semester = Semester.current)
    raise "Group type does not have collection groups" unless gt.has_collection_groups
    if ministry.nil? && (ministry = derive_ministry).nil?
      logger.info "Warning: In Campus.find_or_create_ministry_group and could not derive a ministry for campus #{self.inspect}"
      return
    end
    if semester.nil? && Semester.current.nil?
      logger.info "Warning: In Campus.find_or_create_ministry_group and did not get a semester and couldn't find the current semester"
      return
    end


    cmg = campus_ministry_groups.find_by_ministry_id(ministry, :joins => :group,
      :conditions => [ "group_type_id = ? AND semester_id = ?", gt.id, semester.id ] )
    if cmg
      group = cmg.group
    else
      group = gt.groups.new :campus_id => self.id, :ministry_id => ministry.id, :semester_id => semester.id
      new_group = true if group
    end
    group.ministry = derive_ministry
    group.derive_name
    group.semester ||= semester
    group.save!


    if new_group
      # if possible move the leaders and co-leaders from the previous collection group over to the new one
      prev_cmg = campus_ministry_groups.find_by_ministry_id(ministry, :joins => :group,
        :conditions => [ "group_type_id = ? AND semester_id = ?", gt.id, semester.previous_semester.id ] )
      prev_group = prev_cmg.group if prev_cmg

      if prev_group.present?
        prev_group.leaders.each { |leader| group.find_or_create_involvement(leader, "#{Group::LEADER}") }
        prev_group.co_leaders.each { |co_leader| group.find_or_create_involvement(co_leader, "#{Group::CO_LEADER}") }
      end
    end


    cmg ||= campus_ministry_groups.create! :ministry => ministry, :group => group

    return group
  end

end
