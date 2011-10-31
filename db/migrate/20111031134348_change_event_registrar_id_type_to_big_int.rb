class ChangeEventRegistrarIdTypeToBigInt < ActiveRecord::Migration
  def self.up
    change_table :events do |e|
      e.change :registrar_event_id, :integer, :limit => 8 # this should result in a bigint
    end
  end

  def self.down
    change_table :events do |e|
      e.change :registrar_event_id, :integer
    end
  end
end
