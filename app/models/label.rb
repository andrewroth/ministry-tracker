class Label < ActiveRecord::Base

  has_many :label_people, :foreign_key => _(:label_id, :label_person)

  def acronym
  	self.content.scan(/\b\w/).join.upcase
  end
end
