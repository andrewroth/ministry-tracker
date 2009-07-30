module Cmt
  CONFIG = {
    # Allow GCX logins.
    # The signup process is slightly different if they want to use GCX.
    # They will be asked to log in with GCX in order to grab their 
    # GCX credentials and tie them to a user.
    :gcx_enabled => true,
    
    # Disable GCX Import functionality
    :gcx_import_disabled => false,

    # Allow local logins.  Either this of gcx_account_enabled must be true.
    :local_enabled => true,

    # Forces users to go through a longer process for validating accounts.
    # Note used yet.
    :full_account_verification => true,
    
    # Removes the options of specifying 'poor' timeslots in timetable
    :hide_poor_status_in_scheduler => true,
    
    # Default ministry name
    :default_ministry_name => 'Campus for Christ',
    
    #Associate person with no ministry to default ministry
    :associate_with_default_ministry => true,
    
    # Default Country - When set, the campus filter is disabled and all 
    # campuses from this country are displayed
    # Set to nil(:campus_scope_country => nil) to disable.
    :campus_scope_country => 'Canada',

    # Disable second address line
    :disable_address2 => false,
    
    # Default website title appearing at the top of the browser
    :web_title => 'Campus for Christ :: Movement Tracker',

    # When no Permission object is found for a controller/action,
    # does the user have permission
    
    :permissions_granted_by_default => true,
    
    #Within the CMT, someone's Responsible Person can promote them to a higher role. 
    #Setting this to true allows RP's to promote students to staff without 
    #having to ask for validation from a Campus Tree Head or someone with a higher role.
    :staff_promote_student_to_staff_by_default => true,
    
    #If this is set to true, any staff can promote a student, even if they are not their RP
    :staff_can_promote_any_student => true,  
    
    #if this is set to true, then only Staff have the permission to promote
    :only_staff_can_promote => true,
    
    # will these show up?
    :disable_group_timetable_impact => true,

    # When enabled, users will be able to use the 'find common times' algorithim when making groups
    :find_common_times_enabled => false

  }
end

