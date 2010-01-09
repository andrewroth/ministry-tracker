class PersonYear < ActiveRecord::Base
  load_mappings

  belongs_to :person
  belongs_to :year_in_school, :foreign_key => 'year_id'
end
