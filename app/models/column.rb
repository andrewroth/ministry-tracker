class Column < ActiveRecord::Base
  load_mappings
  has_many :view_columns
  has_many :view, :through => :view_columns
  
  validates_presence_of :from_clause
  validates_presence_of :select_clause
  validates_presence_of :title
  validates_uniqueness_of :title
  
  def safe_name
    title.gsub(' ','_')
  end
end
