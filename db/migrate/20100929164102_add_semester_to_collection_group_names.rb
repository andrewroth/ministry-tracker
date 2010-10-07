class AddSemesterToCollectionGroupNames < ActiveRecord::Migration
  def self.up

    # the original collection groups were given the Summer 2010 semester, which was wrong
    # now that we're displaying the semester in the group name to users we should correct the semester, which was Fall 2010
    CampusMinistryGroup.all(:joins => :group, :conditions => ["semester_id = ?", 12]).each do |cmg|
      cmg.group.semester_id = 13
      cmg.group.save!
    end

    GroupType.all.each do |gt|
      gt.collection_group_name = "{{campus}} interested in a {{group_type}} for {{semester}}"
      gt.save!
    end
  end

  def self.down
    GroupType.all.each do |gt|
      gt.collection_group_name = "{{campus}} interested in a {{group_type}}"
      gt.save!
    end
  end
end
