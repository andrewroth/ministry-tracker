class AddMissingIndexToNotice < ActiveRecord::Migration
  def self.up
    add_index(:notices, :live)
  end

  def self.down
    remove_index(:notices, :column => :live)
  end
end
