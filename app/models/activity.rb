class Activity < ActiveRecord::Base
  belongs_to :reporter, :class_name => 'Person', :foreign_key => :reporter_id
  belongs_to :reportable, :polymorphic => true

  validates_presence_of :reporter_id
  validates_presence_of :activity_type_id
  validates_presence_of :reportable_type
  validates_presence_of :reportable_id
end
