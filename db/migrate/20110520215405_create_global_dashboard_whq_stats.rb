class CreateGlobalDashboardWhqStats < ActiveRecord::Migration
  def self.up
    create_table :global_dashboard_whq_stats do |t|
      t.string :mcc
      t.integer :month_id
      t.integer :global_country_id
      t.integer :live_exp
      t.integer :live_exp
      t.integer :live_dec
      t.integer :new_grth_mbr
      t.integer :mvmt_mbr
      t.integer :mvmt_ldr
      t.integer :new_staff
      t.integer :lifetime_lab

      t.timestamps
    end
  end

  def self.down
    drop_table :global_dashboard_whq_stats
  end
end
