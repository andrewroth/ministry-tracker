class CreateMinistryInvolvements < ActiveRecord::Migration
  def self.up
    create_table :ministry_involvements do |t|
      t.column :person_id, :integer
      t.column :ministry_id, :integer
      t.column :ministry_role_id, :integer
      t.column :start_date, :date
      t.column :end_date, :date
    end
  end

  def self.down
    drop_table :ministry_involvements
  end
end
