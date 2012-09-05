class Contact < ActiveRecord::Base  

  DEFAULT_SORT_DIRECTION = 'ASC'
  DEFAULT_SORT_COLUMN = 'priority'

  belongs_to :campus
  belongs_to :person
  has_many :notes, :as => :noteable

  def self.table_name
    "sept2012_contacts"
  end
end