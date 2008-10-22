class TrainingCategory < ActiveRecord::Base  
  load_mappings
  acts_as_list
  
  has_many :trainign_questions, :class_name => "TrainingQuestion", :foreign_key => _(:training_category_id, :training_question), :dependent => :destroy
  belongs_to :ministry
  
  validates_presence_of :name
  
  def <=>(other)
    self.position <=> other.position
  end

end
