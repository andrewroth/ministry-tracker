=begin
desc 'Print out all defined routes in match order, with names.'
task :actions => :environment do
  routes = ActionController::Routing::Routes.routes.collect do |route|
    name = ActionController::Routing::Routes.named_routes.routes.index(route).to_s
    verb = route.conditions[:method].to_s.upcase
    segs = route.segments.inject("") { |str,s| str << s.to_s }
    segs.chop! if segs.length > 1
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    throw ({:name => name, :verb => verb, :segs => segs, :reqs => reqs}.to_yaml)
  end
  name_width = routes.collect {|r| r[:name]}.collect {|n| n.length}.max
  verb_width = routes.collect {|r| r[:verb]}.collect {|v| v.length}.max
  segs_width = routes.collect {|r| r[:segs]}.collect {|s| s.length}.max
  routes.each do |r|
    puts "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:segs].ljust(segs_width)} #{r[:reqs]}"
  end
end
=end

desc 'Print out all defined routes in match order, with names.'
task :actions => :environment do
  actions_by_controller = {}
  routes = ActionController::Routing::Routes.routes.collect do |route|
    action = route.requirements[:action]
    controller = route.requirements[:controller]
    
    actions_by_controller[controller] ||= []
    actions_by_controller[controller] << action
  end
  
  puts actions_by_controller.to_yaml
end
