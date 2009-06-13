Permission.seed(:controller, :action) do |p|
  sr.controller = 'groups'
  sr.action = 'index'
  sr.description = 'View Groups'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'groups'
  sr.action = 'new'
  sr.description = 'Create Groups'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'groups'
  sr.action = 'edit'
  sr.description = 'Edit Groups'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'people'
  sr.action = 'new'
  sr.description = 'Add New People'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'imports'
  sr.action = 'new'
  sr.description = 'Bulk Import People'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'ministries'
  sr.action = 'new'
  sr.description = 'Create New Ministries'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'ministries'
  sr.action = 'edit'
  sr.description = 'Edit Ministries'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'ministry_roles'
  sr.action = 'edit'
  sr.description = 'Edit Ministry Roles'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'ministry_roles'
  sr.action = 'new'
  sr.description = 'Create Ministry Roles'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'involvement_questions'
  sr.action = 'new'
  sr.description = 'Create Involvement Questions'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'training_questions'
  sr.action = 'new'
  sr.description = 'Create Training Questions'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'views'
  sr.action = 'new'
  sr.description = 'Create Directory Views'
end

Permission.seed(:controller, :action) do |p|
  sr.controller = 'custom_attributes'
  sr.action = 'new'
  sr.description = 'Create Custom Attributes'
end