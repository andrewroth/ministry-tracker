class RemoveGermanyMinistry < ActiveRecord::Migration
  def self.up
    # remove the C4C Germany that somebody made
    Ministry.find_by_name("Campus for Christ - Germany").destroy
  end

  def self.down
    # no
  end
end
