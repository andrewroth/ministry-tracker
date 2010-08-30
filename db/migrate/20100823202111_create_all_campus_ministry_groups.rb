class CreateAllCampusMinistryGroups < ActiveRecord::Migration
  def self.up
    CmtGeo.campuses_for_country("CAN").each do |campus|
      campus.ensure_campus_ministry_groups_created
    end
  end

  def self.down
  end
end
