class CreateContractSignatures < ActiveRecord::Migration
  def self.up
    begin
      create_table :contract_signatures do |t|
        t.integer :contract_id
        t.integer :person_id
        t.boolean :agreement
        t.string :signature
        t.datetime :signed_at

        t.timestamps
      end
      add_index ContractSignature.table_name, :contract_id
      add_index ContractSignature.table_name, :person_id
    rescue
    end
  end

  def self.down
    begin
      remove_index ContractSignature.table_name, :contract_id
      remove_index ContractSignature.table_name, :person_id
      drop_table :contract_signatures
    rescue
    end
  end
end
