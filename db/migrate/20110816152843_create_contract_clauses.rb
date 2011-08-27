class CreateContractClauses < ActiveRecord::Migration
  def self.up
    begin
      create_table :contract_clauses do |t|
        t.integer :contract_id
        t.integer :order
        t.string :heading
        t.text :text
        t.boolean :checkbox

        t.timestamps
      end
      add_index ContractClauses.table_name, :contract_id
      add_index ContractClauses.table_name, :order
    rescue
    end
  end

  def self.down
    begin
      remove_index ContractClauses.table_name, :contract_id
      remove_index ContractClauses.table_name, :order
      drop_table :contract_clauses
    rescue
    end
  end
end
