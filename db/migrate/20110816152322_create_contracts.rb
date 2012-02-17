class CreateContracts < ActiveRecord::Migration
  def self.up
    begin
      create_table :contracts do |t|
        t.string :title
        t.string :agreement_clause

        t.timestamps
      end
    rescue
    end
  end

  def self.down
    begin
      drop_table :contracts
    rescue
    end
  end
end
