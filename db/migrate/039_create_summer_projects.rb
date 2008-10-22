class CreateSummerProjects < ActiveRecord::Migration
  def self.up
    create_table :summer_projects do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :summer_projects
  end
end
