desc 'Create a permissions hash template for the authorize function in app controller'
task :permissions => :environment do
  
  # Collect permissions using routes
  actions_by_controller = {}
  routes = ActionController::Routing::Routes.routes.collect do |route|
    action = route.requirements[:action]
    controller = route.requirements[:controller]
    
    actions_by_controller[controller] ||= []
    actions_by_controller[controller] << action
  end
  
  # Display permissions
  permissions = "PERMISSION_MAPINGS = {\n"
  i = 0
  # Controllers
  actions_by_controller.each_key { |controller|
    permissions << "  '#{controller}' => {\n"
    j = 0
    
    # Actions
    for action in actions_by_controller[controller]
      permissions << "    '#{action}' => { :controller => '', :action => '' }"
      
      # To prevent the "," from being displayed on the last element
      j+= 1
      if j != actions_by_controller[controller].length
        permissions << ",\n"
      else
        permissions << "\n"
      end
    end

    # To prevent the "," from being displayed on the last element
    i+= 1
    if i != actions_by_controller.length
      permissions << "  },\n"
    else
      permissions << "  }\n"
    end
  }
  permissions << "}"
  puts permissions  
end
