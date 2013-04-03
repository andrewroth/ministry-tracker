class Note < ActiveRecord::Base
  load_mappings

  belongs_to :person
  belongs_to :noteable, :polymorphic => true

  validates_presence_of :person_id
  validates_presence_of :content
  validates_presence_of :noteable_id
  validates_presence_of :noteable_type
end
