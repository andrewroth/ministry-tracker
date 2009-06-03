require_model 'school_year'

class SchoolYear < ActiveRecord::Base
  def level() year_id.to_s end
end
