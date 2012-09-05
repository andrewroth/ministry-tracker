class Note < ActiveRecord::Base
  belongs_to :person
  belongs_to :noteable, :polymorphic => true
end
