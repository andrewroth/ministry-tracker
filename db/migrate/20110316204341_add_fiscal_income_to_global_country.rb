class AddFiscalIncomeToGlobalCountry < ActiveRecord::Migration
  def self.up
    add_column :global_countries, :locally_funded_FY10, :integer
    add_column :global_countries, :total_income_FY10, :integer
  end

  def self.down
    remove_column :global_countries, :locally_funded_FY10
    remove_column :global_countries, :total_income_FY10
  end
end
