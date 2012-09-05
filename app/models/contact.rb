class Contact < ActiveRecord::Base  

  DEFAULT_SORT_DIRECTION = 'ASC'
  DEFAULT_SORT_COLUMN = 'priority'

  belongs_to :campus
  belongs_to :person

  def self.table_name
    "sept2012_contacts"
  end
end