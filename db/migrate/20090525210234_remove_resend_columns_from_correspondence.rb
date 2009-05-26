class RemoveResendColumnsFromCorrespondence < ActiveRecord::Migration
  def self.up
    remove_column :correspondences, :resend_if_not_acknowledged
    remove_column :correspondences, :resend_delay
    remove_column :correspondences, :resend_count
  end

  def self.down
    add_column :correspondences, :resend_if_not_acknowledged, :default => false
    add_column :correspondences, :resend_delay, :default => 24.hours.to_i
    add_column :correspondences, :resend_count, :default => 3
  end
end
