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
  p.controller = 'groups'
  p.action = 'compare_timetables'
  p.description = 'Compare Timetables'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'groups'
  p.action = 'set_start_time'
  p.description = 'Set Group Start Time'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'accept_request'
  p.description = 'Accept Group Join Requests'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'new'
  p.description = 'Add people to a group'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'joingroup'
  p.description = 'Request to join any group'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'change_level'
  p.description = 'Change the level of someone invlved in a group'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'transfer'
  p.description = 'Move someone from one group to another'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'new'
  p.description = 'Add/remove people to any group'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'group_involvements'
  p.action = 'destroy_own'
  p.description = 'Person can remove themselves from a group'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'directory'
  p.description = 'View Directory'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'search'
  p.description = 'Search for People'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'advanced'
  p.description = 'Use Advanced Search'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'new'
  p.description = 'Add New People'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'add_student'
  p.description = 'Add New Students'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'change_ministry'
  p.description = 'Change Current Ministry View'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'change_view'
  p.description = 'Change Directory View'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'show'
  p.description = 'View Profiles'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'edit'
  p.description = 'Edit Profiles'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'staff'
  p.action = 'index'
  p.description = 'View Leaders/Staff'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'imports'
  p.action = 'new'
  p.description = 'Bulk Import People'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'manage'
  p.action = 'index'
  p.description = 'Access to the Manage Section'
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
  p.controller = 'ministries'
  p.action = 'switch_list'
  p.description = 'Switch Ministries List'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministries'
  p.action = 'switch_apply'
  p.description = 'Switch Ministries Apply'
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
  p.description = 'Create Training Items'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'training_questions'
  p.action = 'edit'
  p.description = 'Modify Training Items'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'training_categories'
  p.action = 'new'
  p.description = 'Create Training Categories'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'views'
  p.action = 'new'
  p.description = 'Create Directory Views'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'view_columns'
  p.action = 'new'
  p.description = 'Add and remove column to/from views'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'views'
  p.action = 'edit'
  p.description = 'Create Directory Views'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'custom_attributes'
  p.action = 'new'
  p.description = 'Create Custom Attributes (Note: You still need to enable the individual custom attribute types as well)'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'involvement_questions'
  p.action = 'new'
  p.description = 'Create Involvement Custom Attributes'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'profile_questions'
  p.action = 'new'
  p.description = 'Create Profile Questions'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'customize'
  p.action = 'show'
  p.description = 'Customizes A Ministry (based on what your other permissions are)'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'dorms'
  p.action = 'new'
  p.description = 'Customizes A Ministry (based on what your other permissions are)'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'timetables'
  p.action = 'show'
  p.description = 'View the timetables of other people'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'timetables'
  p.action = 'edit'
  p.description = 'Edit the timetables of other people'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'campus_involvements'
  p.action = 'new'
  p.description = 'Remove People From Campuses'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'campus_involvements'
  p.action = 'edit'
  p.description = 'Edit Campus Involvements'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'campus_involvements'
  p.action = 'index'
  p.description = 'List Campus Involvements'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministry_involvements'
  p.action = 'new'
  p.description = 'Remove People From Ministries'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministry_involvements'
  p.action = 'edit'
  p.description = 'Edit Ministry Involvements'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'ministry_involvements'
  p.action = 'index'
  p.description = 'List Ministry Involvements'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'change_ministry'
  p.description = 'Switch to viewing another ministry in the directory'
end
 
Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'email'
  p.description = 'Email people off the directory'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'people'
  p.action = 'change_ministry_and_goto_directory'
  p.description = 'Change ministry'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'training_questions'
  p.action = 'edit'
  p.description = 'Modify Training Items'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'dorms'
  p.action = 'new'
  p.description = 'Customizes A Ministry (based on what your other permissions are)'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'emails'
  p.action = 'new'
  p.description = 'ability to send emails'
end

Permission.seed(:controller, :action) do |p|
  p.controller = 'emails'
  p.action = 'index'
  p.description = 'manage active emails being sent out'
end
