class CreateCorrespondenceTypes < ActiveRecord::Migration
  def self.up
    create_table :correspondence_types, :primary_key => :id do |t|
      t.integer :id
      t.string :name
      t.integer :overdue_lifespan
      t.integer :expiry_lifespan
      t.string :actions_now_task
      t.string :actions_overdue_task
      t.string :actions_followup_task
      t.text :redirect_params
      t.string :redirect_target_id_type
    end
  end

  def self.down
    drop_table :correspondence_types
  end
end
