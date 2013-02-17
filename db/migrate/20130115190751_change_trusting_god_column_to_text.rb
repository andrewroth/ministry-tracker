class ChangeTrustingGodColumnToText < ActiveRecord::Migration
  def self.up
    change_column :contacts, :what_i_am_trusting_god_to_do_next, :text
  end

  def self.down
  end
end
