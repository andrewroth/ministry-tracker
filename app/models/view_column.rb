class ViewColumn < ActiveRecord::Base
  load_mappings
  belongs_to :view
  belongs_to :column
  acts_as_list :scope => :view
  
  validates_presence_of _(:column_id)
  validates_presence_of _(:view_id)
  
  def after_create
    view.build_query_parts!
  end
end
