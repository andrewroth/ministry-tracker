class CreateGroupInvolvements < ActiveRecord::Migration
  def self.up
    create_table :group_involvements do |t|
      t.column :person_id, :integer
      t.column :group_id, :integer
    end
    add_index :group_involvements, [:person_id, :group_id], :unique => true, :name => 'person_id_group_id'
  end

  def self.down
    drop_table :group_involvements
  end
end
