
class Contact < ActiveRecord::Base
  def self.table_name() "sept2012_contacts" end
    
  # Labels
  #has_many :label_people, :class_name => "LabelPerson", :foreign_key => _(:person_id, :label_id)
  #has_many :labels, :through => :label_people, :order => "#{Label.table_name}.#{_(:priority)} asc"


end
