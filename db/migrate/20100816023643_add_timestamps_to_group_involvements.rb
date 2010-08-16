class AddTimestampsToGroupInvolvements < ActiveRecord::Migration
  def self.up
    add_timestamps GroupInvolvement.table_name
  end

  def self.down
    remove_timestamps GroupInvolvement.table_name
  end
end
