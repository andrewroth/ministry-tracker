class CreateRecruitments < ActiveRecord::Migration
  def self.up
    create_table :recruitments do |t|
      t.integer :person_id
      t.integer :recruiter_id
      t.integer :status_id
      t.boolean :interested_in_field_staff
      t.boolean :interested_in_international_field_staff
      t.boolean :interested_in_creative_communications
      t.boolean :interested_in_francophone_ministry
      t.boolean :interested_in_expansion_team
      t.boolean :interested_in_global_impact_team
      t.boolean :interested_in_student_hq
      t.boolean :interested_in_hq
      t.boolean :interested_in_other

      t.timestamps
    end
  end

  def self.down
    drop_table :recruitments
  end
end
