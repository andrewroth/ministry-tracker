Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'index'
  p.description = 'List Groups'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'new'
  p.description = 'Create Groups'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'edit'
  p.description = 'Edit Groups'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'join'
  p.description = 'Join Groups'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'show'
  p.description = 'Show Group (Lists members)'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'new'
  p.description = 'Add New People'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'imports'
  p.action = 'new'
  p.description = 'Bulk Import People'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministries'
  p.action = 'new'
  p.description = 'Create New Ministries'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministries'
  p.action = 'edit'
  p.description = 'Edit Ministries'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministry_roles'
  p.action = 'edit'
  p.description = 'Edit Ministry Roles'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministry_roles'
  p.action = 'new'
  p.description = 'Create Ministry Roles'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'involvement_questions'
  p.action = 'new'
  p.description = 'Create Involvement Questions'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'training_questions'
  p.action = 'new'
  p.description = 'Create Training Questions'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'views'
  p.action = 'new'
  p.description = 'Create Directory Views'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'custom_attributes'
  p.action = 'new'
  p.description = 'Create Custom Attributes'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'directory'
  p.description = 'View Directory'
end
