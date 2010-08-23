class MoveAllGroupsToSummer2010 < ActiveRecord::Migration
  def self.up
    Group.connection.execute("UPDATE groups SET semester_id = #{Semester.current.id}")
  end

  def self.down
  end
end
