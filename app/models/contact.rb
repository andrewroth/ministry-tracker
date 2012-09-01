class Contact < ActiveRecord::Base  
  belongs_to :campus
  belongs_to :person

  def self.table_name
    "sept2012_contacts"
  end
end