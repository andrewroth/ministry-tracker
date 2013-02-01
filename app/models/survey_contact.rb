class SurveyContact < ActiveRecord::Base
  load_mappings

  DEFAULT_SORT_DIRECTION = 'ASC'
  DEFAULT_SORT_COLUMN = 'priority'

  belongs_to :campus
  belongs_to :person
  has_many :notes, :as => :noteable
  has_many :activities, :as => :reportable

  def self.table_name
    "sept2012_contacts"
  end
end