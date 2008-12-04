class Permission < ActiveRecord::Base
  load_mappings
  validates_presence_of :description, :controller, :action
  
  def validate
    controller = "#{self.controller}_controller".classify.constantize
    controller_methods = controller.methods - controller.hidden_actions
    errors.add_to_base('Action name isn\'t valid on that controller.') unless controller_methods.include?(self.action)
  end
end
