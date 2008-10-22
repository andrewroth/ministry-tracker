class CreateSummerProjectApplications < ActiveRecord::Migration
  def self.up
    create_table :summer_project_applications do |t|
      t.integer :summer_project_id, :person_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :summer_project_applications
  end
end
